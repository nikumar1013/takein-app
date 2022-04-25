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
        guestTableView.rowHeight = UITableView.automaticDimension
        guestTableView.estimatedRowHeight = 300
        guestTableView.layer.cornerRadius = 10
        guestTableView.backgroundColor =  UIColor(named: "tableViewColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        guestTableView.backgroundColor =  UIColor(named: "tableViewColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestCellIdentifier", for: indexPath) as! GuestListViewCell
        cell.remove_button.layer.cornerRadius = 10
        cell.contentView.backgroundColor = UIColor(named: "tableViewColor")
        return cell
    }
}
