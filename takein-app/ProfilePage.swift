//
//  ProfilePage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit

class upcomingEventCell: UITableViewCell {
    @IBOutlet weak var event_name: UILabel!
    @IBOutlet weak var host_name: UILabel!
    @IBOutlet weak var event_description: UILabel!
    @IBOutlet weak var event_timing: UILabel!
    @IBOutlet weak var event_picture: UIImageView!
}

class ProfilePage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var upcomingEventsTableView: UITableView!
    
//    @IBOutlet weak var upcomingEventsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        upcomingEventsTableView.delegate = self
        upcomingEventsTableView.dataSource = self
//        upcomingEventsTableView.rowHeight = 300
        upcomingEventsTableView.rowHeight = UITableView.automaticDimension
        upcomingEventsTableView.estimatedRowHeight = 600
        upcomingEventsTableView.layer.cornerRadius=10

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.tabBarController?.navigationItem.hidesBackButton = true
//        upcomingEventsTableView.rowHeight = UITableView.automaticDimension
//        upcomingEventsTableView.estimatedRowHeight = 600

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? SettingsPage {
            nextVC.delegate = self
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as! upcomingEventCell

            return cell
    }


}
