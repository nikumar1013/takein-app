//
//  MyEventsPage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit

// custom cell for the my events page, must contain the event name,timing, guest number and event description attributes.
class EventsTableViewCell: UITableViewCell {
    @IBOutlet weak var event_name: UILabel!
    @IBOutlet weak var event_timing: UILabel!
    @IBOutlet weak var guest_number: UILabel!
    @IBOutlet weak var event_description: UILabel!
    
}


class MyEventsPage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    @IBOutlet weak var eventTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        eventTableView.delegate = self
        eventTableView.dataSource = self
        eventTableView.layer.cornerRadius=10
        eventTableView.rowHeight = UITableView.automaticDimension
        eventTableView.estimatedRowHeight = 300
        let fetchedResults = retrieveDarkMode()
        if fetchedResults.count > 0 {
            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
                if darkmode == true {
                        // for darkMode
                        self.view.backgroundColor = UIColor(rgb: 0x424841)
                    eventTableView.backgroundColor = UIColor(rgb: 0x5D665C)
                        
                    } else {
                        // for light mode
                        self.view.backgroundColor = UIColor(rgb: 0xFFFBD4)
                        eventTableView.backgroundColor = UIColor(rgb: 0xE7E0B8)

                    }
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        let fetchedResults = retrieveDarkMode()
        if fetchedResults.count > 0 {
            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
                if darkmode == true {
                        // for darkMode
                        self.view.backgroundColor = UIColor(rgb: 0x424841)
                    eventTableView.backgroundColor = UIColor(rgb: 0x5D665C)
                        
                    } else {
                        // for light mode
                        self.view.backgroundColor = UIColor(rgb: 0xFFFBD4)
                        eventTableView.backgroundColor = UIColor(rgb: 0xE7E0B8)

                    }
            }
        }
    }
    
    func switchToDarkMode() {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventsTableViewCell
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
