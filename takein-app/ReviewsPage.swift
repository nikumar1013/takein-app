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
    
    @IBOutlet weak var avgStarOne: UIImageView!
    @IBOutlet weak var avgStarTwo: UIImageView!
    @IBOutlet weak var avgStarThree: UIImageView!
    @IBOutlet weak var avgStarFour: UIImageView!
    @IBOutlet weak var avgStarFive: UIImageView!
    var averageStarRatingList: [UIImageView]!
    
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
        
        self.averageStarRatingList =  [avgStarFour, avgStarFive, avgStarOne, avgStarTwo, avgStarThree]
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
//        let profileImageRef = self.database.reference(withPath: "pictureIds").child("\(self.profileName)")
//        profileImageRef.observeSingleEvent(of: .value, with: { snapshot in
//            let profPicId = snapshot.childSnapshot(forPath: "profilePictureId").value
//            let folderReference = Storage.storage().reference(withPath: "profileImages/\(profPicId!)")
//            folderReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
//                if(error != nil) {
//                    print(error)
//                    print("FAILURE")
//                } else {
//                    let profilePic: UIImage = UIImage(data: data!)!
//                    self.userPhoto.image = profilePic
//                }
//            }
//        })
        self.userPhoto.image =  UIImage(named: "seat")
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
                            self.totalRatings += Int(curEvent.rating)
                            self.totalStars += 5
                            
                            self.reviewList.append(curEvent)
                            
                            
                            let avg = (Double(self.totalRatings) / Double(self.totalStars)) * 5
                            print("running avg: ", avg)
                            self.averageRating.text = String(avg)// String(format: "%.2f", avg)
                            print("This is the event list count")
                            self.setAverageStars(avg: avg)
                            print(self.reviewList.count)
                            self.reviewsTableView.reloadData()
                            
                        }
                        
                    })
                }
            }
        })
//        for review in reviewList {
//            print("THE RATING FOR THIS REVIEW IS ", review.rating)
//            self.totalRatings += Int(review.rating)
//            self.totalStars += 5
//        }
//        let avg = Double(self.totalStars) / Double(self.totalRatings)
//        averageRating.text = String(self.totalStars)// String(format: "%.2f", avg)
    }
    
    func setAverageStars(avg: Double) {
        var halfRating = 1
        var numFullStars = Int(floor(avg))
        print("floor avg is: ")
        if(floor(avg) == avg) {
            halfRating = 0
        }
        var numEmptyStars = 5 - halfRating - numFullStars
        for i in 0 ... numFullStars - 1 {
            self.averageStarRatingList[i].image = UIImage(systemName: "star.fill")
        }
        if(halfRating == 1) {
            self.averageStarRatingList[numFullStars].image = UIImage(systemName: "star.leadinghalf.filled")
        }
        let firstEmptyIndex = 5 - numEmptyStars
        if(numFullStars + halfRating < 5) {
            for i in firstEmptyIndex ... 4 {
                self.averageStarRatingList[i].image = UIImage(systemName: "star")
            }
        }
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
//        let profileImageRef = self.database.reference(withPath: "pictureIds").child("\(currentUser.reviewer)")
//        profileImageRef.observeSingleEvent(of: .value, with: { snapshot in
//            let profPicId = snapshot.childSnapshot(forPath: "profilePictureId").value
//            let folderReference = Storage.storage().reference(withPath: "profileImages/\(profPicId!)")
//            folderReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
//                if(error != nil) {
//                    print(error)
//                    print("FAILURE")
//                } else {
//                    let profilePic: UIImage = UIImage(data: data!)!
//                    cell.author_profile_picture.image = profilePic
//                }
//            }
//        })
        
        
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
