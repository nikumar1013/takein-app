//
//  MyEventsPage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit
import CoreData
import Firebase
// custom cell for the my events page, must contain the event name,timing, guest number and event description attributes.
class EventsTableViewCell: UITableViewCell {
    @IBOutlet weak var event_name: UILabel!
    @IBOutlet weak var event_timing: UILabel!
    @IBOutlet weak var guest_number: UILabel!
    @IBOutlet weak var event_description: UILabel!
    @IBOutlet weak var eventPicture: UIImageView!
}


class MyEventsPage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let storage = Storage.storage().reference()
    private let database = Database.database()
    var cEvent = Event(title: "", location: "", date: Date(), startTime: "", endTime: "", totalCapacity: "", photoURL: "", host: "", drinks: "", appetizers: "", entrees: "", desserts: "", description: "", eventID: "", guests: "")
    
    var eventList:[Event] = []
    @IBOutlet weak var eventTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        eventTableView.delegate = self
        eventTableView.dataSource = self
        eventTableView.layer.cornerRadius=10
        eventTableView.rowHeight = UITableView.automaticDimension
        eventTableView.estimatedRowHeight = 300

        
        eventTableView.backgroundColor =  UIColor(named: "tableViewColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        eventTableView.backgroundColor =  UIColor(named: "tableViewColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        eventList = []
        populateEventTable()
    }
    
    func populateEventTable() {
        
        //create a list of event objects     init(title: String, location: String, date: Date, startTime: String, endTime: String, totalCapacity: Int, photoURL: String)
        print("GOT IN HERE")
        let eventIDRef = self.database.reference(withPath: "events").child("\(getUserName()!)")
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
                                desserts: eventSnapshot.childSnapshot(forPath: "desserts").value as! String,
                                description: eventSnapshot.childSnapshot(forPath: "description").value as! String,
                                eventID: eventId,
                                guests:eventSnapshot.childSnapshot(forPath: "guestList").value as! String
                            )
                            if getUserName() == curEvent.host{
                                self.eventList.append(curEvent)
                            }
                            
                            print("This is the event list count")
                            print(self.eventList.count)
                            self.eventTableView.reloadData()
                            
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
    
    func switchToDarkMode() {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventsTableViewCell

        cell.contentView.backgroundColor = UIColor(named: "tableViewColor")
        let curEvent = eventList[indexPath.row]
        cell.event_name.text = curEvent.title
        cell.event_description.text = curEvent.description
        cell.event_timing.text = "\(curEvent.startTime) - \(curEvent.endTime)"
        cell.guest_number.text = curEvent.guests
        
        // load the event picture
        let folderReference = Storage.storage().reference(withPath: "eventImages/\(curEvent.photoURL)")
        folderReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if(error != nil) {
                print(error)
                print("FAILURE")
            } else {
                let eventPic: UIImage = UIImage(data: data!)!
                cell.eventPicture.image = eventPic
            }
        }
            return cell
    }
    
    // when a row is selected show that particular events page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("The indexpath is \(indexPath.row)")
        cEvent  = eventList[indexPath.row]
        performSegue(withIdentifier: "getEventDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getEventDetails",
           let nextVC = segue.destination as? EventDetailsViewController {
            nextVC.curEvent = self.cEvent
            
        }
        if segue.identifier == "getToGuestList",
           let nextVC = segue.destination as? GuestListPage {
            print("got in here")
            print(cEvent.guests)
            nextVC.curEvent = self.cEvent
            
        }
//
        
    }

    @IBAction func goToGuestList(_ sender: UIButton) {
        //getToGuestList
        var superview = sender.superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? UITableViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = eventTableView.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }
        // We've got the index path for the cell that contains the button, now do something with it.
        print("button is in row \(indexPath.row)")
        cEvent = eventList[indexPath.row]
        print(cEvent.guests)
        performSegue(withIdentifier: "getToGuestList", sender: nil)
        
    }
}
