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
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var reserveButton: UIButton!
    
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
    var curEvent = Event(title: "", location: "", date: Date(), startTime: "", endTime: "", totalCapacity: "0", photoURL: "", host: "", drinks: "", appetizers: "", entrees: "", desserts: "", description: "",  eventID: "", guests: "", seatsLeft: "0")
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
        if hostUser == getUserName() {
            reserveButton.isHidden = true
        }
        let dateFormatter = DateFormatter()
        
        date.text = dateFormatter.string(from:curEvent.date) + "\t\(curEvent.startTime) - \(curEvent.endTime)"
        descriptionBox.layer.cornerRadius = 25;
        descriptionBox.layer.masksToBounds = true;
        
        var menuString = "Drinks:\n"
        var foodList = curEvent.drinks.split(separator: ",")
        menuString = buildMenuString(currentMenu: menuString, items: foodList)
        menuString += "Appetizers:\n"
        foodList = curEvent.appetizers.split(separator: ",")
        menuString = buildMenuString(currentMenu: menuString, items: foodList)
        menuString += "Entree:\n"
        foodList = curEvent.entrees.split(separator: ",")
        menuString = buildMenuString(currentMenu: menuString, items: foodList)
        menuString += "Dessert:\n"
        foodList = curEvent.desserts.split(separator: ",")
        menuString = buildMenuString(currentMenu: menuString, items: foodList)
    
        menuLabel.text = menuString
        menuBox.layer.cornerRadius = 25;
        menuBox.layer.masksToBounds = true;
        
        detailsBox.layer.cornerRadius = 25;
        detailsBox.layer.masksToBounds = true;
        
        hostBox.layer.cornerRadius = 25;
        hostBox.layer.masksToBounds = true;
        
        //should be the USERNAME, not email!
        hostNameButton.setTitle(hostUser, for: .normal)
        
//         load the event picture
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
//        self.eventPicture.image = UIImage(named: "seat")
        
        eventTitle.text = curEvent.title
        capacityLabel.text = "\(curEvent.seatsLeft) out of \(curEvent.totalCapacity) seats left"
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
    
    func buildMenuString(currentMenu: String, items: [String.SubSequence]) -> String {
        var menu = currentMenu
        for item in items {
            menu += "\t•\(item)\n"
        }
        return menu
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
        print("MADE IT TO THE ADD ATT FUNCTION \t", curEvent.eventID)
        
                var event = self.database.reference(withPath: "eventDetails").child("\(curEvent.eventID)")
        let username = getUserName()
        var guestList = ""
        event.observeSingleEvent(of: .value, with: { [self] eventSnapshot in
                     //update guestlist
                     if eventSnapshot.exists(){
//                         print(eventSnapshot.childSnapshot(forPath: "eventTitle").value as! String)
                         guestList = eventSnapshot.childSnapshot(forPath: "guestList").value as! String
                         var canAddToDB = true
                         if curEvent.seatsLeft == 0 {
                             canAddToDB = false
                             let controller = UIAlertController(
                                 title: "Could not RSVP",
                                 message: "All seats have been taken.",
                                 preferredStyle: .alert)
                             controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                             present(controller, animated: true, completion: nil)
                         }
                         let array_guests = guestList.split(separator: ",")
                         for guest in array_guests {
                             if guest == username! {
                                 canAddToDB = false
                                 let controller = UIAlertController(
                                     title: "Oops",
                                     message: "You have already claimed your seat for this event.",
                                     preferredStyle: .alert)
                                 controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                 present(controller, animated: true, completion: nil)
                             }
                         }
                         if canAddToDB {
                         let updatedSeatsLeft = String(curEvent.seatsLeft - 1)
                            print("UPDATED SEATS LEFT ", updatedSeatsLeft)
                             guestList =  guestList + username! + ","
                             print("this is the guest list")
                             print(guestList)
                             let dateFormatter = DateFormatter()
                             dateFormatter.dateFormat = "MM/dd/YY"
                            let stringDate = dateFormatter.string(from: curEvent.date)
                             
                             let refTwo = self.database.reference(withPath: "eventDetails")
                             let eventRefChild = refTwo.child(curEvent.eventID)
                             
                             let eventFields = ["eventTitle": curEvent.title, "location": curEvent.location, "date": stringDate, "startTime": curEvent.startTime , "endTime": curEvent.endTime, "capacity": String(curEvent.totalCapacity), "seatsLeft": String(updatedSeatsLeft), "drinks": curEvent.drinks,"appetizers":  curEvent.appetizers , "entrees": curEvent.entrees, "desserts": curEvent.desserts, "host": curEvent.host, "pictureURL": curEvent.photoURL, "description": curEvent.description, "guestList": guestList] as [String : Any]
                             eventRefChild.setValue(eventFields)
                         }
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
