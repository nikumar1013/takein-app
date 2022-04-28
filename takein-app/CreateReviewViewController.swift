//
//  CreateReviewViewController.swift
//  takein-app
//
//  Created by Akshay on 4/24/22.
//

import UIKit
import FirebaseStorage
import Firebase
import CryptoKit

class Review {
    var rating: Int
    var description: String
    var reviewer: String
    
    init(rating: String, description: String, reviewer: String) {
        self.description = description
        self.reviewer = reviewer
        self.rating = Int(rating)!
    }
}

class CreateReviewViewController: UIViewController {

    @IBOutlet weak var oneStar: UIButton!
    @IBOutlet weak var twoStar: UIButton!
    @IBOutlet weak var threeStar: UIButton!
    @IBOutlet weak var fourStar: UIButton!
    @IBOutlet weak var fiveStar: UIButton!
    @IBOutlet weak var textDescriptionBox: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var star: [UIButton] = []
    var starsChosen = 0
    var userName:String = "testing123"
    
    private let storage = Storage.storage().reference()
    private let database = Database.database()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.star = [oneStar, twoStar, threeStar, fourStar, fiveStar]
        self.textDescriptionBox.layer.borderWidth = 1
        self.textDescriptionBox.layer.borderColor = UIColor.lightGray.cgColor
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        self.submitButton.setTitleColor(UIColor(named: "standardFontColor"), for: .normal)
        self.submitButton.backgroundColor = UIColor(named: "ButtonColor")
        self.submitButton.layer.cornerRadius = 10.0
//        self.textDescriptionBox.layer.placeholder =
        // Do any additional setup after loading the view.
    }
    
    @IBAction func oneHIt(_ sender: Any) {
        updateStars(numberFilled: 1)
    }
    
    @IBAction func twoClicked(_ sender: Any) {
        updateStars(numberFilled: 2)
    }
    
    @IBAction func threeClicked(_ sender: Any) {
        updateStars(numberFilled: 3)
    }
    
    @IBAction func fourClicked(_ sender: Any) {
        updateStars(numberFilled: 4)
    }
    
    @IBAction func fiveClicked(_ sender: Any) {
        updateStars(numberFilled: 5)
    }
    
    func updateStars(numberFilled: Int) {
        self.starsChosen = numberFilled
        for i in 0 ... numberFilled - 1 {
            star[i].setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        if(numberFilled < 5) {
            for i in numberFilled ... 4 {
                star[i].setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    
    @IBAction func submitReview(_ sender: Any) {
        if(self.starsChosen == 0) {
            let controller = UIAlertController(
                title: "Missing Details",
                message: "Please select a star rating",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
        } else {
            //create event in db under the username of the person BEING REVIEWED
            let ref = self.database.reference(withPath: "reviews")
            // get username remember to ERROR CHECK
//            let username = getUserName()
            let refChild = ref.child(self.userName)
            let reviewID =  UUID().uuidString
            var reviewList = ""
            let reviewIDRef = self.database.reference(withPath: "reviews").child("\(self.userName)")
            reviewIDRef.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    reviewList = snapshot.childSnapshot(forPath: "reviewID").value as! String
                    print("\n\n fetching previous events")
                    print(reviewList)
                    print("this is the event list currently")
                    let events =  reviewList + reviewID + ","
                    print(events)
                }
                
                let uniqueReview = ["reviewID": reviewList + reviewID + ","]
                refChild.setValue(uniqueReview)
                
                let reviewer = getUserName()
                
                let refTwo = self.database.reference(withPath: "reviewDetails")
                let reviewRefChild = refTwo.child(reviewID)
                let reviewFields = ["rating": String(self.starsChosen), "description": self.textDescriptionBox.text!, "reviewer": reviewer]
                reviewRefChild.setValue(reviewFields)
            })
            
            _ = navigationController?.popViewController(animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
