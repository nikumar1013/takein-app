//
//  ReviewsPage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit

class ReviewsPage: UIViewController {

    @IBOutlet weak var reviewsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
      //  self.navigationController?.navigationBar.set
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
