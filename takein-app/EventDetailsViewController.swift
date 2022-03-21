//
//  EventDetailsViewController.swift
//  takein-app
//
//  Created by Akshay on 3/20/22.
//

import UIKit

class EventDetailsViewController:
    
    UIViewController {

//    @IBOutlet weak var eventTableView: ContentSizedTableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionBox: UIStackView!
    
    @IBOutlet weak var menuBox: UIStackView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    let eventDescription = "Join us for an evening of Fall inspired pastries, tea, and cocktails.\nMy partner and I are new to the city, so we are throwing a small get together to hopefully get to know some other people!\nThere is no dress code, but something casual would be preferred. We own two dogs, so feel free to bring your pets! It’s gonna be a fun night, and if you want to bring anything to eat, please feel free.\nIf you are interested, please hit Claim Seat! We’d love to host you <3"
    
    let menu = "•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n•\n"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = eventDescription

        descriptionBox.layer.cornerRadius = 25;
        descriptionBox.layer.masksToBounds = true;
        
        menuLabel.text = menu
        menuBox.layer.cornerRadius = 25;
        menuBox.layer.masksToBounds = true;
        
        // Do any additional setup after loading the view.
    }
    


}
