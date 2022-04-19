//
//  SettingsPage.swift
//  takein-app
//
//  Created by Nikhil Kumar on 3/16/22.
//

import UIKit
import CoreData


var isLight: Bool?

class SettingsPage: UIViewController {


    
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // sets the switch to what the user settings currently are
        if self.traitCollection.userInterfaceStyle == .dark {
            darkModeSwitch.setOn(true, animated:true)
            isLight = false
        } else {
            darkModeSwitch.setOn(false, animated:true)
            isLight = true
        }
        
        // want this enabled to false first
        notificationSwitch.setOn(false, animated:true)
        
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
    }

}
