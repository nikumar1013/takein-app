//
//  ProfilePage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var event_name: UILabel!
    @IBOutlet weak var event_timing: UILabel!
    @IBOutlet weak var event_picture: UIImageView!
    @IBOutlet weak var event_description: UILabel!
}

class ProfilePage: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var upcomingEventsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        upcomingEventsTable.delegate = self
        upcomingEventsTable.dataSource = self
//        upcomingEventsTable.rowHeight = 300
        upcomingEventsTable.rowHeight = UITableView.automaticDimension
        upcomingEventsTable.estimatedRowHeight = 600
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.tabBarController?.navigationItem.hidesBackButton = true

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? SettingsPage {
            nextVC.delegate = self
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileEventCell", for: indexPath) as! ProfileTableViewCell
            return cell
    }

}
