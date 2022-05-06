//
//  GuestListPage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit
import Firebase

class GuestListViewCell: UITableViewCell {
 
    @IBOutlet weak var guest_profile_picture: UIImageView!
    @IBOutlet weak var remove_button: UIButton!
    @IBOutlet weak var guest_name: UIButton!
    
    func switchToDarkMode() {}
    
    
}

class GuestListPage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let storage = Storage.storage().reference()
    private let database = Database.database()

    @IBOutlet weak var guestTableView: UITableView!
    var curEvent = Event(title: "", location: "", date: Date(), startTime: "", endTime: "", totalCapacity: "0", photoURL: "", host: "", drinks: "", appetizers: "", entrees: "", desserts: "", description: "",  eventID: "", guests: "", seatsLeft: "0")
    var guestList:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        guestTableView.delegate = self
        guestTableView.dataSource = self
        guestTableView.rowHeight = UITableView.automaticDimension
        guestTableView.estimatedRowHeight = 300
        guestTableView.layer.cornerRadius = 10

        guestTableView.backgroundColor =  UIColor(named: "tableViewColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        print("This is the guest list in this view \(curEvent.guests) ")
        let guests = String(curEvent.guests.dropLast())
        if guests != ""{
            print("these are the guests: \(guests)")
            guestList = guests.components(separatedBy: ",")
            print("this is the guest list: \(guestList)")
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()

        guestTableView.backgroundColor =  UIColor(named: "tableViewColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        let guests = String(curEvent.guests.dropLast())
        if guests != ""{
            guestList = guests.components(separatedBy: ",")
        }else{
            guestList = []
        }
       
    }
    
    func switchToDarkMode() {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestCellIdentifier", for: indexPath) as! GuestListViewCell
            cell.remove_button.layer.cornerRadius = 10
           cell.contentView.backgroundColor = UIColor(named: "tableViewColor")
        let row = indexPath.row
        cell.guest_name.setTitle(guestList[row], for: .normal)
            return cell
    }
    
    @IBAction func remove_clicked(_ sender: UIButton) {
        var superview = sender.superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? UITableViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = guestTableView.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }
        // We've got the index path for the cell that contains the button, now do something with it.
        print("button is in row \(indexPath.row)")
        print("TRYING TO REMOVE GUEST LIST")
        print("This is cur guest list: \(guestList)")
        let curGuest = guestList[indexPath.row]
        
        let ref = self.database.reference(withPath: "events")
        // get username remember to ERROR CHECK
        let guest_username = curGuest
        print("THIS IS THE GUEST NAME \(guest_username)")
        let refChild = ref.child(guest_username)
        let eventID =  curEvent.eventID
        var eventList = ""
        var newEventList = ""
        let eventIDRef = self.database.reference(withPath: "events").child("\(guest_username)")
        eventIDRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                eventList = snapshot.childSnapshot(forPath: "eventID").value as! String
                print("\n\n fetching previous events")
                print(eventList)

                let eventListArray =  eventList.components(separatedBy: ",").dropLast()
                for event in eventListArray{
                    if event != self.curEvent.eventID && event != "" {
                        newEventList += event + ","
                    }
                }
//                print("this is the event list currently")
//                eventList =  eventList + eventID + ","
//                print(eventList)
                //asdasd,dasd,
            }
            print("NEW EVENT LIST: ", newEventList)
            let userNameFields = ["eventID": newEventList]
            if newEventList == ""{
                refChild.removeValue()
            }else{
                refChild.setValue(userNameFields)
            }
            
        })
        
        
        
        
        
        
        
        
        guestList.remove(at: indexPath.row)
        print("This is the final guest list \(guestList)")
        var guestListString = ""
        for guest in guestList {
            guestListString += guest + ","
        }
        print("this is the guestlist string:::")
        print(guestListString)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY"
       let stringDate = dateFormatter.string(from: curEvent.date)
        
        let refTwo = self.database.reference(withPath: "eventDetails")
        let eventRefChild = refTwo.child(curEvent.eventID)
        let eventFields = ["eventTitle": curEvent.title, "location": curEvent.location, "date": stringDate, "startTime": curEvent.startTime, "endTime": curEvent.endTime, "capacity": String(curEvent.totalCapacity), "seatsLeft": String(curEvent.seatsLeft + 1), "drinks": curEvent.drinks,"appetizers": curEvent.appetizers, "entrees": curEvent.entrees, "desserts": curEvent.desserts, "host": curEvent.host, "pictureURL": curEvent.photoURL, "description": curEvent.description, "guestList": guestListString] as [String : Any]
        eventRefChild.setValue(eventFields)
        self.guestTableView.reloadData()
        //now rewrite the event into the database
//        performSegue(withIdentifier: "getToGuestList", sender: nil)
        
    }
}
