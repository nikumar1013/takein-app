//
//  SignUpPage.swift
//  takein-app
//
//  Created by Nikhil Kumar on 3/15/22.
//

import UIKit
import Firebase

class SignUpPage: UIViewController {
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
    }
    func switchToDarkMode() {}
}
