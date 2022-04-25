//
//  CreateReviewViewController.swift
//  takein-app
//
//  Created by Akshay on 4/24/22.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.star = [oneStar, twoStar, threeStar, fourStar, fiveStar]
        self.textDescriptionBox.layer.borderWidth = 1
        self.textDescriptionBox.layer.borderColor = UIColor.lightGray.cgColor
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        self.submitButton.setTitleColor(UIColor(named: "standardFontColor"), for: .normal)
        self.submitButton.backgroundColor = UIColor(named: "ButtonColor")
        self.submitButton.layer.cornerRadius = 10.0
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
        
        if numberFilled < 5 {
            for i in numberFilled ... 4 {
                star[i].setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    
    @IBAction func submitReview(_ sender: Any) {
        if self.starsChosen == 0 {
            let controller = UIAlertController(
                title: "Missing Details",
                message: "Please select a star rating",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
        }
    }
    
}
