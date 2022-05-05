//
//  ExplorePage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseStorage
import Firebase

class ExploreViewCell: UITableViewCell {
    @IBOutlet weak var event_name: UILabel!
    @IBOutlet weak var event_distance: UILabel!
    @IBOutlet weak var event_date: UILabel!
    @IBOutlet weak var event_image: UIImageView!
    
    func switchToDarkMode() {}
}

protocol SearchRadiusAdjustment {
    func changeRadius(newRadius: Double)
}

class EventPin : NSObject, MKAnnotation {
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var title: String?

    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

class ExplorePage: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate , MKMapViewDelegate, CLLocationManagerDelegate, SearchRadiusAdjustment {
    var curEvent = Event(title: "", location: "", date: Date(), startTime: "", endTime: "", totalCapacity: "0", photoURL: "", host: "", drinks: "", appetizers: "", entrees: "", desserts: "", description: "",  eventID: "", guests: "", seatsLeft: "0")
    
    @IBOutlet weak var eventTable: UITableView!
    @IBOutlet weak var explorePageMap: MKMapView!
    var eventList:[Event] = []
    
    @IBOutlet weak var radiusControlSegment: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    var currentRadius = 1000.0
    var locationManager: CLLocationManager?
    //private let storage = Storage.storage().reference()
    private let database = Database.database()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        eventTable.delegate = self
        eventTable.dataSource = self
        eventTable.layer.cornerRadius = 10
        eventTable.rowHeight = UITableView.automaticDimension
        eventTable.estimatedRowHeight = 600
        
        // sets the switch to what the user settings currently are
        if isLight == nil{
            if self.traitCollection.userInterfaceStyle == .dark {
                overrideUserInterfaceStyle = .dark
                isLight = false
            } else {
                overrideUserInterfaceStyle = .light
                isLight = true
            }
        }else{
            if (isLight == true) {
                overrideUserInterfaceStyle = .light
            } else {
                overrideUserInterfaceStyle = .dark
            }
        }
        explorePageMap.delegate = self
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }

        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: currentRadius, longitudinalMeters: currentRadius)
            explorePageMap.setRegion(viewRegion, animated: false)
        }

        self.locationManager = locationManager

        DispatchQueue.main.async {
            self.locationManager!.startUpdatingLocation()
        }
        eventTable.backgroundColor =  UIColor(named: "tableViewColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
    }
    
    // when a row is selected show that particular events page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("The indexpath is \(indexPath.row)")
            curEvent  = eventList[indexPath.row]
//        exploreToEvents
        performSegue(withIdentifier: "exploreToEvents", sender: nil)
    }
    
    @IBAction func newSegmentSelected(_ sender: Any) {
        let index = radiusControlSegment.selectedSegmentIndex
        if(index == 0 && currentRadius != 1000.0) {
            changeRadius(newRadius: 1000.0)
        } else if(index == 1 && currentRadius != 3000.0) {
            changeRadius(newRadius: 3000.0)
        } else if(index == 2 && currentRadius != 5000.0) {
            changeRadius(newRadius: 5000.0)
        } else if(index == 3 && currentRadius != 10000.0) {
            changeRadius(newRadius: 10000.0)
        }
    }
    
   /* func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
  
    {
      
        let location = locations[0]
      
        //let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
      
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
      
        let region = MKCoordinateRegion(
            center: myLocation,
            latitudinalMeters: self.currentRadius,
            longitudinalMeters: self.currentRadius)
      
        explorePageMap.setRegion(region, animated: true)
      
        self.explorePageMap.showsUserLocation = true
  
    } */
    
    func setMapInfo(radius: Double) {
//        explorePageMap.delegate = self
//        explorePageMap.showsUserLocation = true
       /* let userLocation = explorePageMap.userLocation
        
        let center = userLocation.location!.coordinate
        let NSdistance = radius // meters
        let EWdistance = radius
        
        // Specify the region that the map should display
        let region = MKCoordinateRegion(
            center:center,
            latitudinalMeters: NSdistance,
            longitudinalMeters: EWdistance)
        
        // commit the region
        explorePageMap.setRegion(region, animated: true) */
        if let userLocation = self.locationManager?.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: currentRadius, longitudinalMeters: currentRadius)
            explorePageMap.setRegion(viewRegion, animated: false)
        }
    }
    
    func populateEventTable() {
        
        //create a list of event objects     init(title: String, location: String, date: Date, startTime: String, endTime: String, totalCapacity: Int, photoURL: String)
        print("GOT IN HERE")
        self.eventList.removeAll()
        let eventDetailsRef = self.database.reference(withPath: "eventDetails")
        eventDetailsRef.observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
//                print("KEY OF CHILD:", child.key, "END")
                guard let dict = child.value as? [String:Any] else {
                    print("Error")
                    return
                }
                let latitude = dict["location"] as Any
                let longtitude = dict["entrees"] as Any
                print(longtitude)
                self.parseEventData(dict: dict, eventID: child.key)
            }
        }
        self.eventList.sort(by: sortEventsByDistance)
        self.eventTable.reloadData()
    }
    
    func sortEventsByDistance(eventOne: Event, eventTwo: Event) -> Bool {
        if let userLocation = self.locationManager?.location?.coordinate {
            guard
                let distOne: Double = self.distance(lat1: userLocation.latitude, long1: userLocation.longitude, lat2: eventOne.lat!, long2: eventOne.long!),
                let  distTwo: Double = self.distance(lat1: userLocation.latitude, long1: userLocation.longitude, lat2: eventTwo.lat!, long2: eventTwo.long!)
            else {
                return false
            }
            print("In sorter")
            return distOne < distTwo
        } else {
            return false;
        }
    }
    
    func parseEventData(dict: [String:Any], eventID: String) {
        let eventName = dict["eventTitle"]
        print(eventName)
        let curEvent = Event(
            title: dict["eventTitle"] as! String,
            location: dict["location"] as! String ,
            date: self.convertStringToDate(dateString: dict["date"] as! String),
            startTime: dict["startTime"] as! String,
            endTime: dict["endTime"] as! String,
            totalCapacity: dict["capacity"] as! String,
            photoURL: dict["pictureURL"] as? String ?? "No picture",
            host: dict["host"] as! String,
            drinks: dict["drinks"] as! String,
            appetizers: dict["appetizers"] as! String,
            entrees: dict["entrees"] as! String,
            desserts: dict["desserts"] as! String,
            description: dict["description"] as! String,
            eventID: eventID ,// probably need to update this correctly
            guests: dict["guestList"] as! String, seatsLeft: dict["seatsLeft"] as! String
            
        )
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(dict["location"] as! String) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let loc = placemarks.first?.location
            else {
                print(error!)
                return
            }
            curEvent.lat = loc.coordinate.latitude
            curEvent.long = loc.coordinate.longitude
          /*  if let userLocation = self.locationManager?.location?.coordinate {
                var dist = self.distance(lat1: userLocation.latitude, long1: userLocation.longitude, lat2: curEvent.lat!, long2: curEvent.long!)
                curEvent.location = "\(dict["location"] as! String) (\(Int(dist!)) meters away)"
            } */
            
            if(curEvent.long != nil && curEvent.lat != nil) {
                self.eventList.append(curEvent)
                print("This is the event list count")
                print(self.eventList.count)
            } else {
                print("Lat or long of event \(eventName!) was nil")
                return
            }
            let newPinLocation = CLLocationCoordinate2DMake(curEvent.lat!, curEvent.long!)
            let newPin: EventPin = EventPin(coordinate: newPinLocation, title: curEvent.title, subtitle: curEvent.location)
            self.explorePageMap.addAnnotation(newPin)
            self.eventList.sort(by: self.sortEventsByDistance)
            self.eventTable.reloadData()
        }
    }
            
    func convertStringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let date = dateFormatter.date(from: dateString)
        print("HERE IS THE DATEEEEEEEEEEEEEEE\n\n")
        print(date ?? "")
        return date!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        if (isLight == true) {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }
        eventTable.backgroundColor =  UIColor(named: "tableViewColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        populateEventTable()
       // explorePageMap.showsUserLocation = true
       // manager.startUpdatingLocation()
    }
    
    func changeRadius(newRadius: Double) {
        self.currentRadius = newRadius
        if let userLocation = self.locationManager?.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: currentRadius, longitudinalMeters: currentRadius)
            explorePageMap.setRegion(viewRegion, animated: false)
        }
    }

    
    @IBAction func filterButtonPressed(_ sender: Any) {
        let controller = UIAlertController(
            title: "Filters",
            message: "Select from the filters below",
            preferredStyle: .actionSheet)
        let radius = UIAlertAction(title: "Radius", style: .default, handler: nil)
        controller.addAction(radius)
        present(controller, animated: true, completion: nil)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("AHAHAHAHAHAHAHAH \(searchText)")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            print("cancel culture")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if(searchBar.text == "") {
            print("In this one for nil")
            populateEventTable()
            return
        } else {
            let filteredAnnotations = self.explorePageMap.annotations.filter { annotation in
                if annotation is MKUserLocation { return false }          // don't remove MKUserLocation
                guard let title = annotation.title else { return false }  // don't remove annotations without any title
                return !title!.contains(searchBar.text!)
                // remove those whose title does not match search string
            }
            self.explorePageMap.removeAnnotations(filteredAnnotations)
            self.eventList = self.eventList.filter { event in
                return event.title.contains(searchBar.text!)
            }
            
            self.eventTable.reloadData()
        }
    }
    
    // Calls when user clicks return on the keyboard
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    // Called when the user clicks on the view outside of the UITextField

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("The event list count is \(eventList.count)")
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as! upcomingEventCell
        // for color scheme
        cell.contentView.backgroundColor = UIColor(named: "tableViewColor")
        let row = indexPath.row
        let curEvent = eventList[row]
      let folderReference = Storage.storage().reference(withPath: "eventImages/\(curEvent.photoURL)")
        folderReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if(error != nil) {
                print(error)
                print("FAILURE")
            } else {
                let eventPic: UIImage = UIImage(data: data!)!
                cell.event_picture.image = eventPic
            }
        }
        
//        cell.event_picture = UIImageView(image: UIImage(named:"seat"))
        cell.event_name.text = curEvent.title
        cell.event_description.text = curEvent.description
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY"
        cell.event_timing.text = dateFormatter.string(from: curEvent.date) + "    \(curEvent.startTime) - \(curEvent.endTime)"
        cell.event_location.text = curEvent.location

        return cell
    }
    
    func distance(lat1: Double, long1: Double, lat2: Double, long2: Double) -> Double? {
        let radLat1 = toRadians(loc: lat1)
        let radLong1 = toRadians(loc: long1)
        let radLat2 = toRadians(loc: lat2)
        let radLong2 = toRadians(loc: long2)
        let dlong: Double = radLong2 - radLong1
        let dlat: Double = radLat2 - radLat1
        
        //distance formula, lookup haversine formula
        let calc: Double = pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlong / 2), 2)
        var answer: Double = 2 * asin(sqrt(calc))
        
        //6371 is the radius of the earth in KM
        answer = answer * 6371
        
        //convert from KM to M
        answer = answer * 1000
        return answer
    }
    
    func toRadians(loc: Double) -> Double {
        let ratio: Double = Double.pi / 180.0
        return (ratio * loc)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adjustRadiusSegue",
           let nextVC = segue.destination as? FilterViewController {
            nextVC.delegate = self
        }
        if segue.identifier == "exploreToEvents",
           let nextVC = segue.destination as? EventDetailsViewController {
            nextVC.curEvent = self.curEvent
        }
    }

}
