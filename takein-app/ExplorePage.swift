//
//  ExplorePage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit
import MapKit
import CoreLocation

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

class ExplorePage: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate , MKMapViewDelegate, CLLocationManagerDelegate, SearchRadiusAdjustment {
    @IBOutlet weak var eventTable: UITableView!
    @IBOutlet weak var explorePageMap: MKMapView!
    var currentRadius = 3_000.0
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        eventTable.delegate = self
        eventTable.dataSource = self
        eventTable.layer.cornerRadius = 10
        eventTable.rowHeight = 125
        
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
    
    func setMapRegion(radius: Double) {
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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        let controller = UIAlertController(
            title: "Filters",
            message: "Select from the filters below",
            preferredStyle: .actionSheet)
        let radius = UIAlertAction(title: "Radius", style: .default, handler: nil)
        controller.addAction(radius)
        present(controller, animated: true, completion: nil)
    }
    
    func switchToDarkMode() {}
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as! ExploreViewCell
         cell.contentView.backgroundColor = UIColor(named: "tableViewColor")
            return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adjustRadiusSegue",
           let nextVC = segue.destination as? FilterViewController {
            nextVC.delegate = self
        }
    }

}
