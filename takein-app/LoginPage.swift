//
//  LoginPage.swift
//  takein-app
//
//  Created by Nikhil Kumar on 3/15/22.
//

import UIKit
import Firebase
import CoreData

class LoginPage: UIViewController, UITextFieldDelegate {

    
    private let storage = Storage.storage().reference()
    private let database = Database.database()
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10.0
        loginButton.setTitleColor(UIColor(named: "standardFontColor") , for: .normal)
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        loginButton.backgroundColor = UIColor(named: "ButtonColor")
        
        usernameField.delegate = self
        passwordField.delegate = self
    }
    
    // Calls when user clicks return on the keyboard
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user clicks on the view outside of the UITextField

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: usernameField.text!, password: passwordField.text!) {
            authResult, error in
            if error != nil {
                if(!self.usernameField.hasText || !self.passwordField.hasText) {
                    if (!self.usernameField.hasText){
                        self.usernameField.shake()
                    } else {
                        self.passwordField.shake()
                    }
                }else{
                    self.usernameField.shake()
                    self.passwordField.shake()
                }
                self.statusLabel.text = "Sign In Failed"
            } else {
                print("all good")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let curUserName = NSEntityDescription.insertNewObject(forEntityName: "CurrentUser", into: context)
                let parsedEmail = self.usernameField.text!.split(separator: ".")
                let emailRef = self.database.reference(withPath: "emails").child(String(parsedEmail[0]))
                var usernameVal:String = ""
                //reads the value of the username associated with the email used to sign in, stores that in coredata
                //and then performs the segue
                emailRef.observeSingleEvent(of: .value, with: { snapshot in
                    let tempUserName = snapshot.childSnapshot(forPath: "userName").value
                    usernameVal = tempUserName as! String
                    curUserName.setValue(usernameVal, forKey: "userName")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                })
            }
        }
    }
    
    func switchToDarkMode() {}
}
