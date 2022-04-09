//
//  CreateEventPage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit
// method to get the correct color based on RBG value


class CreateEventPage: UIViewController {

    @IBOutlet weak var createEvent: UIButton!
    @IBOutlet weak var addGalleryPhoto: UIButton!
    @IBOutlet weak var addPhoto: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // light mode
        self.view.backgroundColor = UIColor(rgb: 0xFFFBD4)
        addPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)
        createEvent.layer.cornerRadius = 10.0
        createEvent.backgroundColor = UIColor(rgb: 0xFF7738)
        // change button text color
        createEvent.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
        addGalleryPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)
        addPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)
    }
    
    func switchToDarkMode() {}
}
