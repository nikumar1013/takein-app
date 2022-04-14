//
//  ProfilePage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit
import CoreData
import Firebase


enum UserNameError: Error {
    case runtimeError(String)
}

class upcomingEventCell: UITableViewCell {
   
    @IBOutlet weak var event_name: UILabel!
    @IBOutlet weak var host_name: UILabel!
    @IBOutlet weak var event_description: UILabel!
    @IBOutlet weak var event_timing: UILabel!
    
    
    
    @IBOutlet weak var event_picture: UIImageView!
    
    func switchToDarkMode() {}
}

class ProfilePage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var myEvents: UIButton!
    private let storage = Storage.storage().reference()
    private let database = Database.database()
    @IBOutlet weak var upcomingEventsTableView: UITableView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var userName: String?
    var emailName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        myEvents.layer.cornerRadius = 10.0
        
        let fetchedResults = retrieveDarkMode()
        if fetchedResults.count > 0 {
            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
                if darkmode == true {
                        // for darkMode
                        self.view.backgroundColor =  UIColor(rgb: 0x565754)
                        myEvents.backgroundColor = UIColor(rgb: 0xB9451D)
                        // change button text color
                        myEvents.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
                        upcomingEventsTableView.backgroundColor = UIColor(rgb: 0x5D665C)
                        
                    } else {
                        // for light mode
                        self.view.backgroundColor =  UIColor(rgb: 0xFFFBD4)
                        myEvents.backgroundColor = UIColor(rgb: 0xFF7738)
                        // change button text color
                        myEvents.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
                        upcomingEventsTableView.backgroundColor = UIColor(rgb: 0xE7E0B8)

                    }
            }
            
            
        }

        upcomingEventsTableView.reloadData()
        upcomingEventsTableView.delegate = self
        upcomingEventsTableView.dataSource = self
        upcomingEventsTableView.rowHeight = UITableView.automaticDimension
        upcomingEventsTableView.estimatedRowHeight = 600
        upcomingEventsTableView.layer.cornerRadius = 10

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myEvents.layer.cornerRadius = 10.0
        
        let fetchedResults = retrieveDarkMode()
        if fetchedResults.count > 0 {
            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
                if darkmode == true {
                    // for darkMode
                    self.view.backgroundColor =  UIColor(rgb: 0x565754)
                    myEvents.backgroundColor = UIColor(rgb: 0xB9451D)
                    myEvents.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
                    upcomingEventsTableView.backgroundColor = UIColor(rgb: 0x5D665C)
                        
                    } else {
                        // for light mode
                        self.view.backgroundColor =  UIColor(rgb: 0xFFFBD4)
                        myEvents.backgroundColor = UIColor(rgb: 0xFF7738)
                        myEvents.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
                        upcomingEventsTableView.backgroundColor = UIColor(rgb: 0xE7E0B8)

                    }
            }
        }
        
        upcomingEventsTableView.reloadData()
        upcomingEventsTableView.rowHeight = UITableView.automaticDimension
        upcomingEventsTableView.estimatedRowHeight = 600
        upcomingEventsTableView.layer.cornerRadius = 10
        retrieveUserdata()
    }
    
    func retrieveUserdata() {
        setUserName()
       // sleep(1)
        print("\(self.userName!) HERE HERE HERE  HERE HERE HERE")
        let profileImageRef = self.database.reference(withPath: "pictureIds").child("\(self.userName!)")
        profileImageRef.observeSingleEvent(of: .value, with: { snapshot in
            let profPicId = snapshot.childSnapshot(forPath: "profilePictureId").value
            //let tempUserName = snapshot.value(forKey: "userName")
            print(profPicId as! String)
            print("In other from firebase")
            let folderReference = Storage.storage().reference(withPath: "profileImages/\(profPicId!)")
            folderReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if(error != nil) {
                    print(error)
                    print("FAILURE")
                } else {
                    let profilePic: UIImage = UIImage(data: data!)!
                    self.profileImage.image = profilePic
                }
                
            }
        })
        //gs://take-in-d0e08.appspot.com/profileImages
        
    }
    
    func setUserName() {
        print("in set username")
        let fetchedResults: [NSManagedObject] = retrieveUserName()
      /*  if(fetchedResults.count < 1) {
            throw UserNameError.runtimeError("Fetched results has no results")
        } */
        if(fetchedResults.count < 1) {
            print("Issue fetching username")
            return
        }
        if let fetchedUserName = fetchedResults[0].value(forKey: "userName") as? String {
            print("No failure casting result username to string")
            self.userName = fetchedUserName
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as! upcomingEventCell
            // for light mode
        
        let fetchedResults = retrieveDarkMode()
        if fetchedResults.count > 0 {
            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
                if darkmode {
                    cell.contentView.backgroundColor = UIColor(rgb: 0x5D665C)
                } else {
                    cell.contentView.backgroundColor = UIColor(rgb: 0xE7E0B8)
                }
            }
        }

            return cell
    }
}
