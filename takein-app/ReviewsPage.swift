//
//  ReviewsPage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit
import CoreData
import Firebase

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var review_content: UILabel!
    @IBOutlet weak var author_profile_picture: UIImageView!
    @IBOutlet weak var reviewer: UILabel!
    
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    
    func switchToDarkMode() {}
}

class ReviewsPage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    var profileName:String = ""
    var delegate: UIViewController!
    @IBOutlet weak var addReviewButton: UIButton!
    
    var reviewList:[Review] = []
    private let storage = Storage.storage().reference()
    private let database = Database.database()
    @IBOutlet weak var reviewsTableView: UITableView!
    
    var totalStars:Int = 0
    var totalRatings:Int = 0
    @IBOutlet weak var averageRating: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userName.text = self.profileName
        //someone shouldn't be able to review themselves
        if(profileName == getUserName()!) {
            addReviewButton.isHidden = true
        }
        reviewsTableView.backgroundColor =  UIColor(named: "tableViewColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        
        reviewsTableView.reloadData()
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        reviewsTableView.rowHeight = UITableView.automaticDimension
        reviewsTableView.estimatedRowHeight = 600
        reviewsTableView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()

        reviewsTableView.backgroundColor =  UIColor(named: "tableViewColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        self.reviewList = []
        reviewsTableView.reloadData()
        reviewsTableView.rowHeight = UITableView.automaticDimension
        reviewsTableView.estimatedRowHeight = 600
        reviewsTableView.layer.cornerRadius = 10
        fetchReviews()
    }
    
    func fetchReviews() {
        let profileImageRef = self.database.reference(withPath: "pictureIds").child("\(self.profileName)")
        profileImageRef.observeSingleEvent(of: .value, with: { snapshot in
            let profPicId = snapshot.childSnapshot(forPath: "profilePictureId").value
            let folderReference = Storage.storage().reference(withPath: "profileImages/\(profPicId!)")
            folderReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if(error != nil) {
                    print(error)
                    print("FAILURE")
                } else {
                    let profilePic: UIImage = UIImage(data: data!)!
                    self.userPhoto.image = profilePic
                }
            }
        })
        populateTable()
    }
    
    func populateTable() {
        let reviewIDRef = self.database.reference(withPath: "reviews").child("\(self.profileName)")
        reviewIDRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                var reviewIds = snapshot.childSnapshot(forPath: "reviewID").value as! String
                reviewIds = String(reviewIds.dropLast())
                let reviewIdList = reviewIds.components(separatedBy: ",")
                for reviewId in reviewIdList {
                    let reviewRef = self.database.reference(withPath: "reviewDetails").child("\(reviewId)")
                    reviewRef.observeSingleEvent(of: .value, with: { reviewSnapshot in
                        if reviewSnapshot.exists() {
                            let eventName = reviewSnapshot.childSnapshot(forPath: "description").value
                            print(eventName)
                            let curEvent = Review(
                                rating: reviewSnapshot.childSnapshot(forPath: "rating").value as! String,
                                description: reviewSnapshot.childSnapshot(forPath: "description").value as! String ,
                                reviewer: reviewSnapshot.childSnapshot(forPath: "reviewer").value as! String
                            )
                            
//                            self.totalStars += curEvent.rating
//                            self.totalRatings += 5
//
                            self.reviewList.append(curEvent)
                            print("This is the event list count")
                            print(self.reviewList.count)
                            self.reviewsTableView.reloadData()
                            
                        }
                        
                    })
                }
            }
        })
        
//        let avg = Double(totalStars) / Double(totalRatings)
//        averageRating.text = String(format: "%.2f", avg)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
    
    func switchToDarkMode() {}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewTableViewCell
//        cell.review_content?.text = "This is the temporary review placeholder"
//        cell.author_profile.setTitle("Bob", for: .normal)
//        cell.contentView.backgroundColor =  UIColor(named: "tableViewColor")
//        return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewTableViewCell
        // for color scheme
        cell.contentView.backgroundColor = UIColor(named: "tableViewColor")
        let row = indexPath.row
        let currentUser = reviewList[row]
        print("HERE IS THE EVENT IMAGES REFERENCE")
        print(currentUser.reviewer)
        print("GGGGGGGGG")
        let profileImageRef = self.database.reference(withPath: "pictureIds").child("\(currentUser.reviewer)")
        profileImageRef.observeSingleEvent(of: .value, with: { snapshot in
            let profPicId = snapshot.childSnapshot(forPath: "profilePictureId").value
            let folderReference = Storage.storage().reference(withPath: "profileImages/\(profPicId!)")
            folderReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if(error != nil) {
                    print(error)
                    print("FAILURE")
                } else {
                    let profilePic: UIImage = UIImage(data: data!)!
                    cell.author_profile_picture.image = profilePic
                }
            }
        })
        
        cell.reviewer.text = currentUser.reviewer
        cell.review_content.text = currentUser.description
        var star = [cell.starOne, cell.starTwo, cell.starThree, cell.starFour, cell.starFive]
        
        let numberFilled = currentUser.rating
        for i in 0 ... numberFilled - 1 {
            star[i]!.image = UIImage(systemName: "star.fill")
        }
        if(numberFilled < 5) {
            for i in numberFilled ... 4 {
                star[i]!.image = UIImage(systemName: "star")
            }
        }
        
        //        @IBOutlet weak var event_picture: UIImageView!
        return cell
    }

}
