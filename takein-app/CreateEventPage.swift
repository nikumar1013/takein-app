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
        
        let fetchedResults = retrieveDarkMode()
        if fetchedResults.count > 0 {
            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
                if darkmode == true {
                    // for darkMode
                    self.view.backgroundColor = UIColor(rgb: 0x424841)
                    addPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)
                    createEvent.backgroundColor = UIColor(rgb: 0xB9451D)
                    } else {
                        // light mode
                        self.view.backgroundColor = UIColor(rgb: 0xFFFBD4)
                        addPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)
                        createEvent.backgroundColor = UIColor(rgb: 0xFF7738)
                    }
            }
        }
        createEvent.layer.cornerRadius = 10.0
        createEvent.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
        addGalleryPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)
        addPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        let fetchedResults = retrieveDarkMode()
        if fetchedResults.count > 0 {
            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
                if darkmode == true {
                    // for darkMode
                    self.view.backgroundColor = UIColor(rgb: 0x424841)
                    addPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)
                    createEvent.backgroundColor = UIColor(rgb: 0xB9451D)
                    } else {
                        // light mode
                        self.view.backgroundColor = UIColor(rgb: 0xFFFBD4)
                        addPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)
                        createEvent.backgroundColor = UIColor(rgb: 0xFF7738)
                    }
            }
        }
        createEvent.layer.cornerRadius = 10.0
        createEvent.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
        addGalleryPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)
        addPhoto.setTitleColor(UIColor(rgb: 0x2BB5AD), for: .normal)

    }
    
    func switchToDarkMode() {}
}
