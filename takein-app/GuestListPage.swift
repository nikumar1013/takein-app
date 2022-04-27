//
//  GuestListPage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit

class GuestListViewCell: UITableViewCell {
 
    @IBOutlet weak var guest_profile_picture: UIImageView!
    @IBOutlet weak var remove_button: UIButton!
    @IBOutlet weak var guest_name: UIButton!
    
    func switchToDarkMode() {}
    
    
}

class GuestListPage: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var guestTableView: UITableView!
    var curEvent = Event(title: "", location: "", date: Date(), startTime: "", endTime: "", totalCapacity: "", photoURL: "", host: "", drinks: "", appetizers: "", entrees: "", desserts: "", description: "",  eventID: "", guests: "")
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
        print("THis is the guest list in this view \(curEvent.guests) ")
        let guests = String(curEvent.guests.dropLast())
        print("these are the guests: \(guests)")
        guestList = guests.components(separatedBy: ",")
        print("this is the guest list: \(guestList)")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()

        guestTableView.backgroundColor =  UIColor(named: "tableViewColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        let guests = String(curEvent.guests.dropLast())
        guestList = guests.components(separatedBy: ",")
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
}
