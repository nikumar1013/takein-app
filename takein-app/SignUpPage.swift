//
//  SignUpPage.swift
//  takein-app
//
//  Created by Nikhil Kumar on 3/15/22.
//

import UIKit
import CryptoKit
import Firebase
import CoreData

extension UIView {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}

class SignUpPage: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    private let storage = Storage.storage().reference()
    private let database = Database.database()
    
    @IBOutlet weak var startedLabel: UILabel!
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
        
        addProfileButton.layer.cornerRadius = 10.0

        
        // gets the keyboard to work correctly
        emailTextField.delegate = self
        userNameField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self

        
        startedLabel.textColor = UIColor(named: "standardFontColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        createAccountButton.backgroundColor = UIColor(named: "ButtonColor")
        createAccountButton.tintColor = UIColor(named: "ButtonColor")
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
                           let ref = self.database.reference(withPath: "users")
                           let eRef = self.database.reference(withPath: "emails")
                           let newEmailItem = ["email" : emailText]
                           let newUserNameItem = ["userName" : userText]
                           //print(userRef)
                           let parsedEmail = emailText.split(separator: ".")
                           let emailRef = eRef.child(String(parsedEmail[0]))
                           let userRef = ref.child("\(userText)")
                           userRef.setValue(newEmailItem)
                           emailRef.setValue(newUserNameItem)
                           let appDelegate = UIApplication.shared.delegate as! AppDelegate
                           let context = appDelegate.persistentContainer.viewContext
                          
                           let curUserName = NSEntityDescription.insertNewObject(forEntityName: "CurrentUser", into: context)
                           
                           curUserName.setValue(userText, forKey: "userName")
                           print("got in here")
                           self.performSegue(withIdentifier: "segueIdentifier", sender: nil)
                       } else {
                           print("Signup failed")
                           print(error)
                       }
                   }
       } else {
              print("Bad password")
           self.passwordTextField.shake()
           self.confirmPasswordTextField.shake()
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
