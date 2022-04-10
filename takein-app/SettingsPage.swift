//
//  SettingsPage.swift
//  takein-app
//
//  Created by Nikhil Kumar on 3/16/22.
//

import UIKit
import CoreData


class SettingsPage: UIViewController {


    
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchedResults = retrieveDarkMode()
        if fetchedResults.count > 0 {
            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
                if darkmode == true {
                        // for darkMode
                        self.view.backgroundColor =  UIColor(rgb: 0x565754)
                        darkModeSwitch.setOn(true, animated: true)
                    } else {
                        // for light mode
                        self.view.backgroundColor =  UIColor(rgb: 0xFFFBD4)
                        darkModeSwitch.setOn(false, animated: true)
                    }
            }
        }

        
    }
    
    //Useful function for later
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        // need to have the switches set to the correct values
        let fetchedResults = retrieveDarkMode()
        if fetchedResults.count > 0 {
            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
                if darkmode == true  {
                        // for darkMode
                        self.view.backgroundColor =  UIColor(rgb: 0x565754)
                        darkModeSwitch.setOn(true, animated: true)
                        
                    } else {
                        // for light mode
                        self.view.backgroundColor =  UIColor(rgb: 0xFFFBD4)
                        darkModeSwitch.setOn(false, animated: true)
                        print("got in this view appear 2")

                    }
            }
        }
    }
    
    func switchToDarkMode() {}
    
    func returnToPrevViewController() {
        
    }

    @IBAction func darkModeSwitching(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if (darkModeSwitch.isOn)
        {
            // retrieve dark mode value from core data and update it
            let fetchedResults = retrieveDarkMode()
            if fetchedResults.count > 0 {
                var managedObject = fetchedResults[0]
                managedObject.setValue(true, forKey: "isDarkMode")
            }
            
            // Commit the changes
            do {
                try context.save()
            } catch {
                // If an error occurs
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                print("This ain't working")
                abort()
            }
            print("dark mode activiated")

        }
        else
        {
            // retrieve dark mode value from core data and update it
            let fetchedResults = retrieveDarkMode()
            if fetchedResults.count > 0 {
                var managedObject = fetchedResults[0]
                managedObject.setValue(false, forKey: "isDarkMode")
            }
            
            // Commit the changes
            do {
                try context.save()
            } catch {
                // If an error occurs
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                print("This ain't working")
                abort()
            }
            print("dark mode deactiviated")

        }
    }
    
    @IBAction func notificationSwitch(_ sender: Any) {
    }
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return settings.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
//        let row = indexPath.row
//        cell.textLabel?.text = settings[row]
//        let switchView = UISwitch(frame: .zero)
//
//        if cell.textLabel?.text == "Dark Mode" {
//            switchView.setOn(false, animated: true) // need some way of remembering this
//        }
//        else {
//            switchView.setOn(true, animated: true)
//
//        }
//
//        switchView.tag = row
//        cell.accessoryView = switchView
//
//        return cell
//    }
}
