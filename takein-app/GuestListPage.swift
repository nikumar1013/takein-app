//
//  GuestListPage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit

class GuestListViewCell: UITableViewCell {
 
    @IBOutlet weak var guest_profile_picture: UIImageView!
    @IBOutlet weak var remove_button: UIButton!
    
    @IBOutlet weak var guest_name: UIButton!
    @IBOutlet weak var guest_number: UILabel!
    
    
}

class GuestListPage: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var guestTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        guestTableView.delegate = self
        guestTableView.dataSource = self
//        guestTableView.rowHeight = 125
        guestTableView.rowHeight = UITableView.automaticDimension
        guestTableView.estimatedRowHeight = 300

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestCellIdentifier", for: indexPath) as! GuestListViewCell

            return cell
    }

}
