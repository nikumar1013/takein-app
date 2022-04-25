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
    
    @IBOutlet weak var event_name: UILabel!
    @IBOutlet weak var host_name: UILabel!
    @IBOutlet weak var event_description: UILabel!
    @IBOutlet weak var event_timing: UILabel!
    
    @IBOutlet weak var event_picture: UIImageView!
    
    func switchToDarkMode() {}
}

class ProfilePage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var eventList:[Event] = []
    @IBOutlet weak var myEvents: UIButton!
    private let storage = Storage.storage().reference()
    private let database = Database.database()
    @IBOutlet weak var upcomingEventsTableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var userName: String?
    var emailName: String?
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
                if(error != nil) {
                    print(error)
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
        
        //create a list of event objects     init(title: String, location: String, date: Date, startTime: String, endTime: String, totalCapacity: Int, photoURL: String)
        print("GOT IN HERE")
        let eventIDRef = self.database.reference(withPath: "events").child("\(self.userName!)")
        eventIDRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                var eventIds = snapshot.childSnapshot(forPath: "eventID").value as! String
                eventIds = String(eventIds.dropLast())
                let eventIdList = eventIds.components(separatedBy: ",")
                for eventId in eventIdList {
                    let eventRef = self.database.reference(withPath: "eventDetails").child("\(eventId)")
                    eventRef.observeSingleEvent(of: .value, with: { eventSnapshot in
                        if eventSnapshot.exists() {
                            let eventName = eventSnapshot.childSnapshot(forPath: "eventTitle").value
                            print(eventName)
                            let curEvent = Event(
                                title: eventSnapshot.childSnapshot(forPath: "eventTitle").value as! String,
                                location: eventSnapshot.childSnapshot(forPath: "location").value as! String ,
                                date: self.convertStringToDate(dateString: eventSnapshot.childSnapshot(forPath: "date").value as! String),
                                startTime: eventSnapshot.childSnapshot(forPath: "startTime").value as! String,
                                endTime: eventSnapshot.childSnapshot(forPath: "endTime").value as! String,
                                totalCapacity: eventSnapshot.childSnapshot(forPath: "capacity").value as! String,
                                photoURL: eventSnapshot.childSnapshot(forPath: "pictureURL").value as! String,
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
                }
            }
        })
    }
    
    func convertStringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let date = dateFormatter.date(from: dateString)
        print("HERE IS THE DATEEEEEEEEEEEEEEE\n\n")
        print(date ?? "")
        return date!
    }
    
    func setUserName() {
        print("in set username")
        let fetchedResults: [NSManagedObject] = retrieveUserName()
        if(fetchedResults.count < 1) {
            print("Issue fetching username")
            return
        }
        if let fetchedUserName = fetchedResults[fetchedResults.count-1].value(forKey: "userName") as? String {
            print("No failure casting result username to string")
            self.userName = fetchedUserName
        }
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
        print("HERE IS THE EVENT IMAGES REFERENCE")
        print(curEvent.photoURL)
        print("GGGGGGGGG")
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
        
        cell.event_name.text = curEvent.title
        cell.host_name.text = curEvent.host
        cell.event_description.text = ""
        cell.event_timing.text = "\(curEvent.startTime) - \(curEvent.endTime)"
        
        //        @IBOutlet weak var event_picture: UIImageView!
        return cell
    }
}
