//
//  ProfilePage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit

class ProfilePage: UIViewController {

    @IBOutlet weak var upcomingEventsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
