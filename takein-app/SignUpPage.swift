//
//  SignUpPage.swift
//  takein-app
//
//  Created by Nikhil Kumar on 3/15/22.
//

import UIKit
import CryptoKit
import Firebase

class SignUpPage: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let storage = Storage.storage().reference()
    private let database = Database.database()
    @IBOutlet weak var signUpStatus: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var addProfileButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var imageField: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!
    var imagePicked: Data?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addPhotoPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        guard let imageData = image.pngData() else {
            return
        }
        
        imagePicked = imageData
        imageField.image = image
        imageField.isHidden = false
        imageLabel.isHidden = false
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        if(!userNameField.hasText || !emailTextField.hasText ||  !passwordTextField.hasText) {
            return
        }
        
        let userText = userNameField.text!
        let passText = passwordTextField.text!
        let emailText = emailTextField.text!
        if(passwordTextField.text == confirmPasswordTextField.text) {
               Auth.auth().createUser(
                   withEmail: emailTextField.text!,
                   password: passwordTextField.text!) { user, error in
                       if error == nil {
                           Auth.auth().signIn(
                               withEmail: userText,
                               password: passText)
                           self.performImageUpload(userText: userText, emailText: emailText)
                           print("PRE HERE \(emailText)")
                           let ref = self.database.reference(withPath: "users")
                           let newEmailItem = ["email" : emailText]
                           let newUserNameItem = ["userName" : userText]
                           //print(userRef)
                          // let emailRef = ref.child(emailText).childByAutoId()
                           let userRef = ref.child("\(userText)")
                           userRef.setValue(newEmailItem)
                          // emailRef.setValue(newUserNameItem)
                           print("In here, login success")
                           //self.performSegue(withIdentifier: "loginSegue", sender: self.self)
                       } else {
                           print("Signup failed")
                       }
                   }
       } else {
              print("Bad password")
       }
    }
    
    func performImageUpload(userText:String, emailText: String) {
        if(self.imagePicked != nil) {
            let hashName = SHA256.hash(data: self.imagePicked!)
            var hashString = hashName.compactMap { String(format: "%02x", $0) }.joined()
            hashString = hashString + "\(Date().hashValue)"
            storage.child("profileImages/\(hashString)").putData(self.imagePicked!, metadata: nil, completion: {_, error in
                guard error == nil else {
                    print("Upload failure")
                    return
                }
                
                let ref = self.database.reference(withPath: "pictureIds")
                //let emailRef = ref.child("\(emailText)")
                let userRef = ref.child("\(userText)")
                let pictureNameItem = ["profilePictureId" : "\(hashString)"]
                //emailRef.setValue(pictureNameItem)
                userRef.setValue(pictureNameItem)
                
                self.storage.child("profileImages/\(hashString)").downloadURL(completion: {_, error in
                    guard error == nil else {
                        print(" Download URL Failed")
                        return
                    }
                    print("Download URL Success")
                })
            })
        }
    }
        
    func switchToDarkMode() {}
}
