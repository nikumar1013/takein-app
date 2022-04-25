//
//  ReviewsPage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rating: UIImageView!
    @IBOutlet weak var reviewContent: UILabel!
    @IBOutlet weak var authorProfile: UIButton!
    @IBOutlet weak var authorProfilePicture: UIImageView!
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewTableViewCell
        cell.reviewContent?.text = "This is the temporary review placeholder"
        cell.authorProfile.setTitle("Bob", for: .normal)
        cell.contentView.backgroundColor =  UIColor(named: "tableViewColor")
        return cell
    }
    
}
