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
    
    func switchToDarkMode() {}
    
    
}

class GuestListPage: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var guestTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guestTableView.delegate = self
        guestTableView.dataSource = self
        guestTableView.rowHeight = UITableView.automaticDimension
        guestTableView.estimatedRowHeight = 300
        guestTableView.layer.cornerRadius = 10
        
        // light mode
        self.view.backgroundColor = UIColor(rgb: 0xFFFBD4)
        guestTableView.backgroundColor = UIColor(rgb: 0xE7E0B8)
        
    }
    
    func switchToDarkMode() {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestCellIdentifier", for: indexPath) as! GuestListViewCell
        cell.contentView.backgroundColor = UIColor(rgb: 0xE7E0B8)
            return cell
    }
}
