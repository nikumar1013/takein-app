//
//  EventDetailsViewController.swift
//  takein-app
//
//  Created by Akshay on 3/20/22.
//

import UIKit
import Firebase

class EventDetailsViewController: UIViewController {

//    @IBOutlet weak var eventTableView: ContentSizedTableView!
    @IBOutlet weak var hostNameButton: UIButton!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var eventPicture: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionBox: UIStackView!
    
    @IBOutlet weak var menuBox: UIStackView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var detailsBox: UIStackView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var hostBox: UIView!
    var curEvent = Event(title: "", location: "", date: Date(), startTime: "", endTime: "", totalCapacity: "", photoURL: "", host: "", drinks: "", appetizers: "", entrees: "", desserts: "", description: "",  eventID: "", guests: "")
    var hostUser = ""
    
    private let storage = Storage.storage().reference()
    private let database = Database.database()
    
//    let eventDescription = "Join us for an evening of Fall inspired pastries, tea, and cocktails.\nMy partner and I are new to the city, so we are throwing a small get together to hopefully get to know some other people!\nThere is no dress code, but something casual would be preferred. We own two dogs, so feel free to bring your pets! It’s gonna be a fun night, and if you want to bring anything to eat, please feel free.\nIf you are interested, please hit Claim Seat! We’d love to host you <3"
    
//    let menu = "Drinks:\n\t• Black Coffee \n\t• Tea\n\t• Juice\nAppetizers:\n\t• Finger Sandwiches\n\t• Butternut Squash Soup\n\t• Pigs in a Blanket\nEntree:\n\nDessert:\n\t• Pumpkin Spice Cheesecake\n\t• Gingersnap Cookies\n\t• Hazelnut Crepes"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = curEvent.description
        address.text = curEvent.location
        hostUser = curEvent.host
        let dateFormatter = DateFormatter()
        
        date.text = dateFormatter.string(from:curEvent.date) + "\t\(curEvent.startTime) - \(curEvent.endTime)"
        descriptionBox.layer.cornerRadius = 25;
        descriptionBox.layer.masksToBounds = true;
        
        let menu = "Drinks:\n\t• \(curEvent.drinks)\nAppetizers:\n\t• \(curEvent.appetizers)\nEntree:\n\t• \(curEvent.entrees)\nDessert:\n\t• \(curEvent.desserts)"
        
        menuLabel.text = menu
        menuBox.layer.cornerRadius = 25;
        menuBox.layer.masksToBounds = true;
        
        detailsBox.layer.cornerRadius = 25;
        detailsBox.layer.masksToBounds = true;
        
        hostBox.layer.cornerRadius = 25;
        hostBox.layer.masksToBounds = true;
        
        //should be the USERNAME, not email!
        hostNameButton.setTitle(hostUser, for: .normal)
        
        // load the event picture
        let folderReference = Storage.storage().reference(withPath: "eventImages/\(curEvent.photoURL)")
        folderReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if(error != nil) {
                print(error)
                print("FAILURE")
            } else {
                let eventPic: UIImage = UIImage(data: data!)!
                self.eventPicture.image = eventPic
            }
        }
        
        eventTitle.text = curEvent.title
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        
        // sets the color mode to what the user settings currently are
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
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewDidLoad()
        descriptionLabel.text = curEvent.description
        address.text = curEvent.location
        
        // sets the switch to what the user settings currently are
        if (isLight == true) {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }
    }
    
    //pass in username to reviews page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsToReviewSegue",
           let destination = segue.destination as? ReviewsPage {
            destination.profileName = hostUser
        }
    }
    
    @IBAction func reserveButtonPressed(_ sender: Any) {
        let controller = UIAlertController(
            title: "Confirm Reservation",
            message: "Do you want to reserve your seat for \(eventTitle.text!)?",
            preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            _ in
            self.addAttendee()
        }))
        controller.addAction(UIAlertAction(title: "No", style: .cancel))
        present(controller, animated: true, completion: nil)
    }
    
    func addAttendee() {
        print(curEvent.eventID)
                var event = self.database.reference(withPath: "eventDetails").child("\(curEvent.eventID)")
        let username = getUserName()!
        var guestList = ""
        event.observeSingleEvent(of: .value, with: { [self] eventSnapshot in
                     //update guestlist
                     if eventSnapshot.exists(){
//                         print(eventSnapshot.childSnapshot(forPath: "eventTitle").value as! String)
                         guestList = eventSnapshot.childSnapshot(forPath: "guestList").value as! String
                         guestList =  guestList + username + ","
                         print("this is the guest list")
                         print(guestList)
                         let dateFormatter = DateFormatter()
                         dateFormatter.dateFormat = "MM/dd/YY"
                        let stringDate = dateFormatter.string(from: curEvent.date)
                         
                         let refTwo = self.database.reference(withPath: "eventDetails")
                         let eventRefChild = refTwo.child(curEvent.eventID)
                         
                         let eventFields = ["eventTitle": curEvent.title, "location": curEvent.location, "date": stringDate, "startTime": curEvent.startTime , "endTime": curEvent.endTime, "capacity": String(curEvent.totalCapacity), "drinks": curEvent.drinks,"appetizers":  curEvent.appetizers , "entrees": curEvent.entrees, "desserts": curEvent.desserts, "host": username, "pictureURL": curEvent.photoURL, "description": curEvent.description, "guestList": guestList] as [String : Any]
                         eventRefChild.setValue(eventFields)
                     }
                 })
    
    
        


        
        

  
//                eventIds = String(eventIds.dropLast())
//                let eventIdList = eventIds.components(separatedBy: ",")
//                for eventId in eventIdList {
//                    let eventRef = self.database.reference(withPath: "eventDetails").child("\(eventId)")
//                    eventRef.observeSingleEvent(of: .value, with: { eventSnapshot in
//                        if eventSnapshot.exists() {
//                            let eventName = eventSnapshot.childSnapshot(forPath: "eventTitle").value
//                            print(eventName)
//                            let curEvent = Event(
//                                title: eventSnapshot.childSnapshot(forPath: "eventTitle").value as! String,
//                                location: eventSnapshot.childSnapshot(forPath: "location").value as! String ,
//                                date: self.convertStringToDate(dateString: eventSnapshot.childSnapshot(forPath: "date").value as! String),
//                                startTime: eventSnapshot.childSnapshot(forPath: "startTime").value as! String,
//                                endTime: eventSnapshot.childSnapshot(forPath: "endTime").value as! String,
//                                totalCapacity: eventSnapshot.childSnapshot(forPath: "capacity").value as! String,
//                                photoURL: eventSnapshot.childSnapshot(forPath: "pictureURL").value as! String,
//                                host: eventSnapshot.childSnapshot(forPath: "host").value as! String,
//                                drinks: eventSnapshot.childSnapshot(forPath: "drinks").value as! String,
//                                appetizers: eventSnapshot.childSnapshot(forPath: "appetizers").value as! String,
//                                entrees: eventSnapshot.childSnapshot(forPath: "entrees").value as! String,
//                                desserts: eventSnapshot.childSnapshot(forPath: "desserts").value as! String,
//                                description: eventSnapshot.childSnapshot(forPath: "description").value as! String,
//                                eventID: eventId
//                            )
//
//                            self.eventList.append(curEvent)
//                            print("This is the event list count")
//                            print(self.eventList.count)
//                            self.upcomingEventsTableView.reloadData()
//
//                        }
                        

        //get event list for the current event,update and republish
        
    }
    

    


}
