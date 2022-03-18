//
//  SuccessLoginSegue.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit

class SuccessLoginSegue: UIStoryboardSegue {
    override func perform() {
        if let navigationController = source.navigationController as UINavigationController? {
            var controllers = navigationController.viewControllers
            controllers.removeAll()
            controllers.append(destination)
            navigationController.setViewControllers(controllers, animated: true)
        }
    }
}
