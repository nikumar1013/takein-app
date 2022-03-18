//
//  SettingsPage.swift
//  takein-app
//
//  Created by Nikhil Kumar on 3/16/22.
//

import UIKit

class SettingsPage: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingsTableView: UITableView!
    
    let settings = ["Dark Mode", "Notifications", "Search Radius"]
    var delegate: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Temp back button
      /*  let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = backButton
        self.navigationItem.title = "TESTING"
        self.navigationItem.setHidesBackButton(false, animated: false) */
        //self.navigationController?.navigationItem.setHidesBackButton(false, animated: false)
        //self.navigationController?.navigationItem.setHidesBackButton(false, animated: false)
    }
    
    func returnToPrevViewController() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        let row = indexPath.row
    
        cell.textLabel?.text = settings[row]
        
        let switchView = UISwitch(frame: .zero)
        
        if cell.textLabel?.text == "Dark Mode" {
            switchView.setOn(false, animated: true)
        }
        else {
            switchView.setOn(true, animated: true)
        }
        
        switchView.tag = row
        
        cell.accessoryView = switchView
        
        return cell
    }
}
