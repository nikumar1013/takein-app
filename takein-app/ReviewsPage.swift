//
//  ReviewsPage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var rating: UIImageView!
    @IBOutlet weak var review_content: UILabel!
    @IBOutlet weak var author_profile: UIButton!
    @IBOutlet weak var author_profile_picture: UIImageView!
    
    func switchToDarkMode() {}
}

class ReviewsPage: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var reviewsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        reviewsTableView.backgroundColor =  UIColor(named: "tableViewColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        reviewsTableView.rowHeight = 150
    }
    
    //Useful function for later
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()

        reviewsTableView.backgroundColor =  UIColor(named: "tableViewColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func switchToDarkMode() {}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewTableViewCell
        cell.review_content?.text = "This is the temporary review placeholder"
        cell.author_profile.setTitle("Bob", for: .normal)
//        let fetchedResults = retrieveDarkMode()
//        if fetchedResults.count > 0 {
//            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
//                if darkmode {
//                    cell.contentView.backgroundColor =  UIColor(named: "tableViewColor")
//                } else {
//                    cell.contentView.backgroundColor = UIColor(rgb: 0xE7E0B8)
//                }
//            }
//        }
        cell.contentView.backgroundColor =  UIColor(named: "tableViewColor")
        return cell
    }

}
