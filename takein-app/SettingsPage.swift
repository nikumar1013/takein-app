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

        
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
    }
    
    //Useful function for later
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
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
                overrideUserInterfaceStyle = .dark
//                UIWindow().overrideUserInterfaceStyle = UIUserInterfaceStyle.dark
                navigationController!.overrideUserInterfaceStyle = .dark
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
                overrideUserInterfaceStyle = .light
//                UIWindow().overrideUserInterfaceStyle = UIUserInterfaceStyle.light
                navigationController!.overrideUserInterfaceStyle = .light
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

}
