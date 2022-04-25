//
//  ProfilePage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit
import CoreData
import Firebase

enum UserNameError: Error {
    case runtimeError(String)
}

class upcomingEventCell: UITableViewCell {
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var hostName: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventTiming: UILabel!
    @IBOutlet weak var eventPicture: UIImageView!
    
}

class ProfilePage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var eventList:[Event] = []
    var userName: String?
    var emailName: String?
    
    private let storage = Storage.storage().reference()
    private let database = Database.database()
    
    @IBOutlet weak var myEvents: UIButton!
    @IBOutlet weak var upcomingEventsTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myEvents.layer.cornerRadius = 10.0
        upcomingEventsTableView.backgroundColor =  UIColor(named: "tableViewColor")
        myEvents.setTitleColor(UIColor(named: "standardFontColor"), for: .normal)
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        myEvents.backgroundColor = UIColor(named: "ButtonColor")
        upcomingEventsTableView.reloadData()
        upcomingEventsTableView.delegate = self
        upcomingEventsTableView.dataSource = self
        upcomingEventsTableView.rowHeight = UITableView.automaticDimension
        upcomingEventsTableView.estimatedRowHeight = 600
        upcomingEventsTableView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myEvents.layer.cornerRadius = 10.0
        upcomingEventsTableView.backgroundColor =  UIColor(named: "tableViewColor")
        myEvents.setTitleColor(UIColor(named: "standardFontColor"), for: .normal)
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        myEvents.backgroundColor = UIColor(named: "ButtonColor")
        self.eventList = []
        upcomingEventsTableView.reloadData()
        upcomingEventsTableView.rowHeight = UITableView.automaticDimension
        upcomingEventsTableView.estimatedRowHeight = 600
        upcomingEventsTableView.layer.cornerRadius = 10
        retrieveUserdata()
    }
    
    func retrieveUserdata() {
        setUserName()
        let profileImageRef = self.database.reference(withPath: "pictureIds").child("\(self.userName!)")
        nameLabel.text = self.userName!
        profileImageRef.observeSingleEvent(of: .value, with: { snapshot in
            let profPicId = snapshot.childSnapshot(forPath: "profilePictureId").value
            let folderReference = Storage.storage().reference(withPath: "profileImages/\(profPicId!)")
            folderReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if error != nil {
                    print("FAILURE")
                } else {
                    let profilePic: UIImage = UIImage(data: data!)!
                    self.profileImage.image = profilePic
                }
            }
        })
        populateEventTable()
    }
    
    func populateEventTable() {
        // Create a list of event objects
        let eventIDRef = self.database.reference(withPath: "events").child("\(self.userName!)")
        eventIDRef.observeSingleEvent(of: .value, with: { snapshot in
            let eventId = snapshot.childSnapshot(forPath: "eventID").value
            // Now have to create event objects
            let eventRef = self.database.reference(withPath: "eventDetails").child("\(eventId!)")
            eventRef.observeSingleEvent(of: .value, with: { eventSnapshot in
                if eventSnapshot.exists() {
                    //                    let eventName = eventSnapshot.childSnapshot(forPath: "eventTitle").value
                    let curEvent = Event (
                        title: eventSnapshot.childSnapshot(forPath: "eventTitle").value as! String,
                        location: eventSnapshot.childSnapshot(forPath: "location").value as! String ,
                        date: "",
                        startTime: eventSnapshot.childSnapshot(forPath: "startTime").value as! String,
                        endTime: eventSnapshot.childSnapshot(forPath: "endTime").value as! String,
                        totalCapacity: eventSnapshot.childSnapshot(forPath: "capacity").value as! String,
                        photoURL: "",
                        host: eventSnapshot.childSnapshot(forPath: "host").value as! String,
                        drinks: eventSnapshot.childSnapshot(forPath: "drinks").value as! String,
                        appetizers: eventSnapshot.childSnapshot(forPath: "appetizers").value as! String,
                        entrees: eventSnapshot.childSnapshot(forPath: "entrees").value as! String,
                        desserts: eventSnapshot.childSnapshot(forPath: "desserts").value as! String
                    )
                    self.eventList.append(curEvent)
                    print("This is the event list count")
                    print(self.eventList.count)
                    self.upcomingEventsTableView.reloadData()
                }
            })
        })
    }
    
    func setUserName() {
        let fetchedResults: [NSManagedObject] = retrieveUserName()
        if fetchedResults.count < 1 {
            return
        }
        if let fetchedUserName = fetchedResults[fetchedResults.count - 1].value(forKey: "userName") as? String {
            self.userName = fetchedUserName
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as! upcomingEventCell
        cell.contentView.backgroundColor = UIColor(named: "tableViewColor")
        let row = indexPath.row
        let curEvent = eventList[row]
        cell.eventName.text = curEvent.title
        cell.hostName.text = curEvent.host
        cell.eventDescription.text = ""
        cell.eventTiming.text = "\(curEvent.startTime) - \(curEvent.endTime)"
        
        return cell
    }
}
