//
//  ViewController.swift
//  takein-app
//
//  Created by Nikhil Kumar on 3/15/22.
//

import UIKit
import CoreData

func retrieveDarkMode() -> [NSManagedObject] {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName:"DarkMode")
    var fetchedResults:[NSManagedObject]? = nil
    
    do {
        try fetchedResults = context.fetch(request) as? [NSManagedObject]
    } catch {
        // If an error occurs
        let nserror = error as NSError
        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        abort()
    }
    return(fetchedResults)!
}

func retrieveUserName() -> [NSManagedObject] {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName:"CurrentUser")
    var fetchedResults:[NSManagedObject]? = nil
    
    do {
        try fetchedResults = context.fetch(request) as? [NSManagedObject]
    } catch {
        // If an error occurs
        let nserror = error as NSError
        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        abort()
    }
    return(fetchedResults)!
}

// method to get the correct color based on RBG value
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")
       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

class HomePage: UIViewController {

    @IBOutlet weak var login: UIButton!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var signUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login.layer.cornerRadius = 10.0
        signUp.layer.cornerRadius = 10.0
        
        welcomeLabel.textColor = UIColor(named: "standardFontColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        login.backgroundColor = UIColor(named: "ButtonColor")
        signUp.backgroundColor = UIColor(named: "ButtonColor")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        login.layer.cornerRadius = 10.0
        signUp.layer.cornerRadius = 10.0

        welcomeLabel.textColor = UIColor(named: "standardFontColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
        login.backgroundColor = UIColor(named: "ButtonColor")
        signUp.backgroundColor = UIColor(named: "ButtonColor")
    }
    
    
    func switchToDarkMode() {}
}

