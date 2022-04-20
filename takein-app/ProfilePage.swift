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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var userName: String?
    var emailName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        myEvents.layer.cornerRadius = 10.0

        upcomingEventsTableView.backgroundColor =  UIColor(named: "tableViewColor")
        myEvents.setTitleColor(UIColor(named: "standardFontColor"), for: .normal)
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        myEvents.backgroundColor = UIColor(named: "ButtonColor")
        
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

        upcomingEventsTableView.backgroundColor =  UIColor(named: "tableViewColor")
        myEvents.setTitleColor(UIColor(named: "standardFontColor"), for: .normal)
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        myEvents.backgroundColor = UIColor(named: "ButtonColor")
        
        upcomingEventsTableView.reloadData()
        upcomingEventsTableView.rowHeight = UITableView.automaticDimension
        upcomingEventsTableView.estimatedRowHeight = 600
        upcomingEventsTableView.layer.cornerRadius = 10
        retrieveUserdata()
    }
    
    func retrieveUserdata() {
        setUserName()
        let profileImageRef = self.database.reference(withPath: "pictureIds").child("\(self.userName!)")
        nameLabel.text = self.userName!
        profileImageRef.observeSingleEvent(of: .value, with: { snapshot in
            let profPicId = snapshot.childSnapshot(forPath: "profilePictureId").value
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
        
        populateEventTable()
    }
    
    func populateEventTable() {
        let eventRef = self.database.reference(withPath: "events").child("\(self.userName!)")
    }
    
    func setUserName() {
        print("in set username")
        let fetchedResults: [NSManagedObject] = retrieveUserName()
        if(fetchedResults.count < 1) {
            print("Issue fetching username")
            return
        }
        if let fetchedUserName = fetchedResults[fetchedResults.count-1].value(forKey: "userName") as? String {
            print("No failure casting result username to string")
            self.userName = fetchedUserName
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as! upcomingEventCell
            // for color scheme
            cell.contentView.backgroundColor = UIColor(named: "tableViewColor")
            return cell
    }
}
