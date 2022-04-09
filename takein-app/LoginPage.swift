//
//  LoginPage.swift
//  takein-app
//
//  Created by Nikhil Kumar on 3/15/22.
//

import UIKit
import Firebase
import CoreData

class LoginPage: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 10.0
        let fetchedResults = retrieveDarkMode()
        if fetchedResults.count > 0 {
            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
                if darkmode == true {
                        // for darkMode
                        self.view.backgroundColor = UIColor(rgb: 0x424841)
                        loginButton.backgroundColor = UIColor(rgb: 0xFF7738)
                        // change button text color
                        loginButton.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
                        
                    } else {
                        // for light mode
                        self.view.backgroundColor =  UIColor(rgb: 0xFFFBD4)
                        loginButton.backgroundColor = UIColor(rgb: 0xFF7738)
                        // change button text color
                        loginButton.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)

                    }
            }
        }

    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: usernameField.text!, password: passwordField.text!) {
            authResult, error in
            if error != nil {
                self.statusLabel.text = "Sign In Failed"
            } else {
                // currently initalize a darkMode setting preference after signing up (so it only happens once)
                // we probably want to store darkmode preference in db, so it is associated w/ profile and not phone
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let DarkMode = NSEntityDescription.insertNewObject(
                    forEntityName: "DarkMode", into: context)
                
                // Set the attribute values
                DarkMode.setValue(false, forKey: "isDarkMode")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    func switchToDarkMode() {}
}
