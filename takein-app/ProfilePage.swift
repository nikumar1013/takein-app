//
//  ProfilePage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit
import CoreData

class upcomingEventCell: UITableViewCell {
   
    @IBOutlet weak var event_name: UILabel!
    @IBOutlet weak var host_name: UILabel!
    @IBOutlet weak var event_description: UILabel!
    @IBOutlet weak var event_timing: UILabel!
    
    
    
    @IBOutlet weak var event_picture: UIImageView!
    
    func switchToDarkMode() {}
}

class ProfilePage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var myEvents: UIButton!
    
    @IBOutlet weak var upcomingEventsTableView: UITableView!
    var userName: String?
    var emailName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        myEvents.layer.cornerRadius = 10.0
        
        let fetchedResults = retrieveDarkMode()
        if fetchedResults.count > 0 {
            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
                if darkmode == true {
                        // for darkMode
                        self.view.backgroundColor =  UIColor(rgb: 0x565754)
                        myEvents.backgroundColor = UIColor(rgb: 0xB9451D)
                        // change button text color
                        myEvents.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
                        upcomingEventsTableView.backgroundColor = UIColor(rgb: 0x5D665C)
                        
                    } else {
                        // for light mode
                        self.view.backgroundColor =  UIColor(rgb: 0xFFFBD4)
                        myEvents.backgroundColor = UIColor(rgb: 0xFF7738)
                        // change button text color
                        myEvents.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
                        upcomingEventsTableView.backgroundColor = UIColor(rgb: 0xE7E0B8)

                    }
            }
            
            
        }

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
        
        let fetchedResults = retrieveDarkMode()
        if fetchedResults.count > 0 {
            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
                if darkmode == true {
                    // for darkMode
                    self.view.backgroundColor =  UIColor(rgb: 0x565754)
                    myEvents.backgroundColor = UIColor(rgb: 0xB9451D)
                    myEvents.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
                    upcomingEventsTableView.backgroundColor = UIColor(rgb: 0x5D665C)
                        
                    } else {
                        // for light mode
                        self.view.backgroundColor =  UIColor(rgb: 0xFFFBD4)
                        myEvents.backgroundColor = UIColor(rgb: 0xFF7738)
                        myEvents.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
                        upcomingEventsTableView.backgroundColor = UIColor(rgb: 0xE7E0B8)

                    }
            }
        }
        
        upcomingEventsTableView.reloadData()
        upcomingEventsTableView.rowHeight = UITableView.automaticDimension
        upcomingEventsTableView.estimatedRowHeight = 600
        upcomingEventsTableView.layer.cornerRadius = 10
        


    }
    
    func switchToDarkMode() {}
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as! upcomingEventCell
            // for light mode
        
        let fetchedResults = retrieveDarkMode()
        if fetchedResults.count > 0 {
            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
                if darkmode {
                    cell.contentView.backgroundColor = UIColor(rgb: 0x5D665C)
                } else {
                    cell.contentView.backgroundColor = UIColor(rgb: 0xE7E0B8)
                }
            }
        }

            return cell
    }
}
