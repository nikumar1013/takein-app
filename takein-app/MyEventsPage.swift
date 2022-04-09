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
        
        // light mode
        self.view.backgroundColor = UIColor(rgb: 0xFFFBD4)
        eventTableView.backgroundColor = UIColor(rgb: 0xE7E0B8)
        
    }
    
    func switchToDarkMode() {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventsTableViewCell
            cell.contentView.backgroundColor = UIColor(rgb: 0xE7E0B8)
            return cell
    }

}
