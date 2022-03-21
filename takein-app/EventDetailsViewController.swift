//
//  EventDetailsViewController.swift
//  takein-app
//
//  Created by Akshay on 3/20/22.
//

import UIKit

class EventDetailsCell: UITableViewCell {
    
    @IBOutlet weak var descriptionText: UILabel!
}

class EventDetailsViewController:
    
    UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var eventTableView: UITableView!
    let eventDescription = "Join us for an evening of Fall inspired pastries, tea, and cocktails.\nMy partner and I are new to the city, so we are throwing a small get together to hopefully get to know some other people!\nThere is no dress code, but something casual would be preferred. We own two dogs, so feel free to bring your pets! It’s gonna be a fun night, and if you want to bring anything to eat, please feel free.\nIf you are interested, please hit Claim Seat! We’d love to host you <3"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.rowHeight = UITableView.automaticDimension
        eventTableView.estimatedRowHeight = 600
        eventTableView.delegate = self
        eventTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! EventDetailsCell
        cell.descriptionText.text = eventDescription
        return cell
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
