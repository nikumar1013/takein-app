//
//  LoginPage.swift
//  takein-app
//
//  Created by Nikhil Kumar on 3/15/22.
//

import UIKit
import Firebase

class LoginPage: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: usernameField.text!, password: passwordField.text!) {
            authResult, error in
            if error != nil {
                self.statusLabel.text = "Sign In Failed"
            } else {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    func switchToDarkMode() {}
}
