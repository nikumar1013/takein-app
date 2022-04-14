//
//  CreateEventPage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit
import FirebaseStorage
import Firebase
import CryptoKit
// method to get the correct color based on RBG value

class Event {
    var title: String
    var location: String
    var date: Date
    var startTime: String
    var endTime: String
    var totalCapacity: Int
    var seatsLeft: Int
    var drinks:[String]?
    var appetizers:[String]?
    var entrees:[String]?
    var desserts:[String]?
    var photoURL: String //??? is this clean
    
    init(title: String, location: String, date: Date, startTime: String, endTime: String, totalCapacity: Int, photoURL: String) {
        self.title = title
        self.location = location
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.totalCapacity = totalCapacity
        self.seatsLeft = totalCapacity
        self.photoURL = photoURL
    }
}

class CreateEventPage: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var createEvent: UIButton!
    @IBOutlet weak var addGalleryPhoto: UIButton!
    @IBOutlet weak var addPhoto: UIButton!
    @IBOutlet weak var imagePreview: UIImageView!
    
    //for the choosers in the date/time fields
    let datePicker = UIDatePicker()
    let startTimePicker = UIDatePicker()
    let endTimePicker = UIDatePicker()
    
    //text fields
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var startTimeField: UITextField!
    @IBOutlet weak var endTimeField: UITextField!
    @IBOutlet weak var capacityField: UITextField!
    @IBOutlet weak var drinksField: UITextField!
    @IBOutlet weak var appetizersField: UITextField!
    @IBOutlet weak var entreeField: UITextField!
    @IBOutlet weak var dessertsField: UITextField!
    
    var imagePicked: Data?
    var necessaryFields: [UITextField] = []
    
    private let storage = Storage.storage().reference()
    private let database = Database.database()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchedResults = retrieveDarkMode()
        if fetchedResults.count > 0 {
            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
                if darkmode == true {
                    // for darkMode
                    self.view.backgroundColor = UIColor(rgb: 0x424841)
                    addPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)
                    createEvent.backgroundColor = UIColor(rgb: 0xB9451D)
                    } else {
                        // light mode
                        self.view.backgroundColor = UIColor(rgb: 0xFFFBD4)
                        addPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)
                        createEvent.backgroundColor = UIColor(rgb: 0xFF7738)
                    }
            }
        }
        createEvent.layer.cornerRadius = 10.0
        createEvent.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
        addGalleryPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)
        addPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)
        
        imagePreview.contentMode = .scaleAspectFit
        self.necessaryFields = [titleField, locationField, dateField, startTimeField, endTimeField, capacityField]
        createDatePicker()
    }
    
    func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        startTimePicker.preferredDatePickerStyle = .wheels
        startTimePicker.datePickerMode = .time
        
        endTimePicker.preferredDatePickerStyle = .wheels
        endTimePicker.datePickerMode = .time
        
        //create toolbars to select the date and put it into the fields.
        
        let toolbarDate = UIToolbar()
        toolbarDate.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(setDateValue))
        toolbarDate.setItems([done], animated: true)
        
        let toolbarStartTime = UIToolbar()
        toolbarStartTime.sizeToFit()
        let doneStartTime = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(setStartTimeValue))
        toolbarStartTime.setItems([doneStartTime], animated: true)
        
        let toolbarEndTime = UIToolbar()
        toolbarEndTime.sizeToFit()
        let doneEndTime = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(setEndTimeValue))
        toolbarEndTime.setItems([doneEndTime], animated: true)
        
        dateField.inputAccessoryView = toolbarDate
        dateField.inputView = datePicker
        
        startTimeField.inputAccessoryView = toolbarStartTime
        startTimeField.inputView = startTimePicker
        
        endTimeField.inputAccessoryView = toolbarEndTime
        endTimeField.inputView = endTimePicker
    }
    
    @objc func setStartTimeValue() {
        let timeFormat = DateFormatter()
        timeFormat.dateStyle = .none
        timeFormat.timeStyle = .short
        startTimeField.text = timeFormat.string(from: startTimePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func setEndTimeValue() {
        let timeFormat = DateFormatter()
        timeFormat.dateStyle = .none
        timeFormat.timeStyle = .short
        endTimeField.text = timeFormat.string(from: endTimePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func setDateValue() {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.timeStyle = .none
        dateField.text = dateFormat.string(from: datePicker.date)
        self.view.endEditing(true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        let fetchedResults = retrieveDarkMode()
        if fetchedResults.count > 0 {
            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
                if darkmode == true {
                    // for darkMode
                    self.view.backgroundColor = UIColor(rgb: 0x424841)
                    addPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)
                    createEvent.backgroundColor = UIColor(rgb: 0xB9451D)
                    } else {
                        // light mode
                        self.view.backgroundColor = UIColor(rgb: 0xFFFBD4)
                        addPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)
                        createEvent.backgroundColor = UIColor(rgb: 0xFF7738)
                    }
            }
        }
        createEvent.layer.cornerRadius = 10.0
        createEvent.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
        addGalleryPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)
        addPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)

    }
    
    @IBAction func uploadImagePressed(_ sender: Any) {
        let gallery = UIImagePickerController()
        gallery.sourceType = .photoLibrary
        gallery.delegate = self
        gallery.allowsEditing = true
        present(gallery, animated: true)
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
        imagePreview.image = image
        imagePreview.isHidden = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraController(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func checkNecessaryFields() -> Bool {
        var errors = false
        for field in necessaryFields {
            if(!field.hasText) {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
                errors = true
            } else {
                field.layer.borderColor = UIColor.white.cgColor
            }
        }
        if(errors) {
            let controller = UIAlertController(
                title: "Missing Details",
                message: "Please fill in info for the fields outlined in red, as they are necessary.",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
    @IBAction func createEvent(_ sender: Any) {
        //error checking
        if checkNecessaryFields() {
        
            //pack everything into an object, template code is here, we are still working on the DB structure in storing an event, so it will be ready by the final.
            
            //upload to db
    //        if(self.imagePicked != nil) {
    //            let hashName = SHA256.hash(data: self.imagePicked!)
    //            var hashString = hashName.compactMap { String(format: "%02x", $0) }.joined()
    //            hashString = hashString + "\(Date().hashValue)"
    //            storage.child("eventImages/\(hashString)").putData(self.imagePicked!, metadata: nil, completion: {_, error in
    //                guard error == nil else {
    //                    print("Upload failure")
    //                    return
    //                }
    //
    //                let ref = self.database.reference(withPath: "pictureIds")
    //                //let emailRef = ref.child("\(emailText)")
    //                let userRef = ref.child("\(userText)")
    //                let pictureNameItem = ["profilePictureId" : "\(hashString)"]
    //                //emailRef.setValue(pictureNameItem)
    //                userRef.setValue(pictureNameItem)
    //
    //                self.storage.child("profileImages/\(hashString)").downloadURL(completion: {_, error in
    //                    guard error == nil else {
    //                        print(" Download URL Failed")
    //                        return
    //                    }
    //                    print("Download URL Success")
    //                })
    //            })
    //        }
            //upon success, add to an [] of this user's current event urls or something (would this be to the db)
            
            //set notification to get notice an hour before you host the event.
            
            let eventTitle = titleField.text!
            
            let notification = UNMutableNotificationContent()
            notification.title = "Upcoming Hosting Event"
            notification.subtitle = ""
            notification.body = "Your event, \(eventTitle), will begin shortly."
            
            //parse date, year, month, time, and  from the respective fields
            let notificationDate = datePicker.date
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year], from: notificationDate)
            let year = components.year
            components = calendar.dateComponents([.month], from: notificationDate)
            let month = components.month
            components = calendar.dateComponents([.day], from: notificationDate)
            let day = components.day
            
            let notificationTime = startTimePicker.date
            var timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "H"
            let hour = Int(timeFormatter.string(from: notificationTime))
            
            timeFormatter.dateFormat = "m"
            let minute = Int(timeFormatter.string(from: notificationTime))
            
            // set up the notification trigger
            var notificationDateSetup = DateComponents()
            notificationDateSetup.calendar = Calendar.current
            notificationDateSetup.hour = hour!
            notificationDateSetup.minute = minute!
            notificationDateSetup.day = day!
            notificationDateSetup.month = month!
            notificationDateSetup.year = year!
            
            let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: notificationDateSetup, repeats: false)
            let notificationIdentifier = UUID().uuidString
            
            let request = UNNotificationRequest(
                identifier:  notificationIdentifier,
                content: notification,
                trigger: calendarTrigger)

            // submit the request to iOS
            UNUserNotificationCenter.current().add(request) {
                (error) in
                print("Request error: ", error as Any)
            }
        }
    }
    
    
    func switchToDarkMode() {}
}
