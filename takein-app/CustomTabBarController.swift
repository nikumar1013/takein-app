//
//  CustomTabBarController.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    let TAB_NAMES: [String] = ["Profile Page", "Explore Page"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var counter: Int = 0
        
        for tabItem in self.tabBar.items! {
            tabItem.isEnabled = true
            
            if counter == 0 {
                tabItem.image = UIImage(systemName: "person.circle")
            } else {
                tabItem.image = UIImage(systemName: "map.circle")
            }
            
            tabItem.title = TAB_NAMES[counter]
            counter += 1
        }
    }
    
}
