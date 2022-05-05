//
//  SettingsPage.swift
//  takein-app
//
//  Created by Nikhil Kumar on 3/16/22.
//

import UIKit
import CoreData
import UserNotifications
import Firebase

var isLight: Bool?
var isNotification: Bool!

class SettingsPage: UIViewController {


    
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    
    private let storage = Storage.storage().reference()
    private let database = Database.database()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("This is the notification value")
        print(isNotification)

        // sets the switch to what the user settings currently are
        if self.traitCollection.userInterfaceStyle == .dark {
            darkModeSwitch.setOn(true, animated:true)
            isLight = false
        } else {
            darkModeSwitch.setOn(false, animated:true)
            isLight = true
        }
        
        if isNotification == nil {
            let username = getUserName()
            let notificationRef = self.database.reference(withPath: "users").child("\(username!)")
            notificationRef.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    let notif = snapshot.childSnapshot(forPath: "notification").value as! String
                    if (notif == "false") {
                        self.notificationSwitch.setOn(false, animated:true)
                        isNotification = false
                    }else{
                        self.notificationSwitch.setOn(true, animated:true)
                        isNotification = true
                    }
                }
                print("This is the user notification")
                print(isNotification)
            })
        }else{
            if (isNotification == true){
                self.notificationSwitch.setOn(true, animated:true)
            } else {
                self.notificationSwitch.setOn(false, animated:true)
            }
        }
        
        // need to get notification preference from database

        



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
        if (darkModeSwitch.isOn)
        {
            navigationController!.overrideUserInterfaceStyle = .dark
            isLight = false
            print("dark mode activiated")
        }
        else
        {
            navigationController!.overrideUserInterfaceStyle = .light
            isLight = true
            print("dark mode deactiviated")
        }
    }
    
    @IBAction func notificationSwitch(_ sender: Any) {
        //get the email
        
        let username = getUserName()
        var emailString = ""
        let notificationRef = self.database.reference(withPath: "users").child("\(username!)")
        notificationRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                let emailString = snapshot.childSnapshot(forPath: "email").value as! String
            }
            print("This is the user notification")
            print(isNotification)
        })
        if (notificationSwitch.isOn)
        {
            isNotification = true
            self.notificationSwitch.setOn(true, animated:true)
            // need to get notification preference from database
            let username = getUserName()
            let ref = self.database.reference(withPath: "users")
            let notifRef = ref.child("\(username!)")
            
            let newNotificationItem = ["email" : emailString, "notification": "true"]
            notifRef.setValue(newNotificationItem)
            
        }
        else
        {
            isNotification = false
            self.notificationSwitch.setOn(false, animated:true)
            // need to get notification preference from database
            let username = getUserName()
            let ref = self.database.reference(withPath: "users")
            let notifRef = ref.child("\(username!)")
            
            let newNotificationItem = ["email" : emailString, "notification": "false"]
            notifRef.setValue(newNotificationItem)
        }
        

    }
    
    

}
