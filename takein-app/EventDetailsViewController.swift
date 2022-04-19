//
//  EventDetailsViewController.swift
//  takein-app
//
//  Created by Akshay on 3/20/22.
//

import UIKit

class EventDetailsViewController: UIViewController {

//    @IBOutlet weak var eventTableView: ContentSizedTableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionBox: UIStackView!
    
    @IBOutlet weak var menuBox: UIStackView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var detailsBox: UIStackView!
    @IBOutlet weak var eventTitle: UILabel!
    
    let eventDescription = "Join us for an evening of Fall inspired pastries, tea, and cocktails.\nMy partner and I are new to the city, so we are throwing a small get together to hopefully get to know some other people!\nThere is no dress code, but something casual would be preferred. We own two dogs, so feel free to bring your pets! It’s gonna be a fun night, and if you want to bring anything to eat, please feel free.\nIf you are interested, please hit Claim Seat! We’d love to host you <3"
    
    let menu = "Drinks:\n\t• Black Coffee \n\t• Tea\n\t• Juice\nAppetizers:\n\t• Finger Sandwiches\n\t• Butternut Squash Soup\n\t• Pigs in a Blanket\nEntree:\n\nDessert:\n\t• Pumpkin Spice Cheesecake\n\t• Gingersnap Cookies\n\t• Hazelnut Crepes"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = eventDescription

        descriptionBox.layer.cornerRadius = 25;
        descriptionBox.layer.masksToBounds = true;
        
        menuLabel.text = menu
        menuBox.layer.cornerRadius = 25;
        menuBox.layer.masksToBounds = true;
        
        detailsBox.layer.cornerRadius = 25;
        detailsBox.layer.masksToBounds = true;
        
        eventTitle.text = "Outdoor Fall Bonfire"
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        
        // sets the color mode to what the user settings currently are
        if isLight == nil{
            if self.traitCollection.userInterfaceStyle == .dark {
                overrideUserInterfaceStyle = .dark
                isLight = false
            } else {
                overrideUserInterfaceStyle = .light
                isLight = true
            }
        }else{
            if (isLight == true) {
                overrideUserInterfaceStyle = .light
            } else {
                overrideUserInterfaceStyle = .dark
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        // sets the switch to what the user settings currently are
        if (isLight == true) {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }
    }
    
    @IBAction func reserveButtonPressed(_ sender: Any) {
        let controller = UIAlertController(
            title: "Confirm Reservation",
            message: "Do you want to reserve your seat for \(eventTitle.text!)?",
            preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        controller.addAction(UIAlertAction(title: "No", style: .cancel))
        present(controller, animated: true, completion: nil)
    }
    
    


}
