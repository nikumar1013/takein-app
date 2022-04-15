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
        
        let fetchedResults = retrieveDarkMode()
        if fetchedResults.count > 0 {
            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
                print("This is the darkmode value \(darkmode)")
                if darkmode == true {
                        // for darkMode
                    print("get into home page")
                       self.view.backgroundColor = UIColor(rgb: 0x424841)
                    self.login.backgroundColor = UIColor(rgb: 0xB9451D)
                    self.signUp.backgroundColor = UIColor(rgb: 0xB9451D)
                    self.welcomeLabel.textColor = UIColor(rgb: 0xFFFFFF)
                        
                    } else {
                        // for light mode
                       self.view.backgroundColor = UIColor(rgb: 0xFFFBD4)
                        self.login.backgroundColor = UIColor(rgb: 0xFF7738)
                        self.signUp.backgroundColor = UIColor(rgb: 0xFF7738)
                        self.welcomeLabel.textColor = UIColor(rgb: 0x000000)
                    }
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        login.layer.cornerRadius = 10.0
        signUp.layer.cornerRadius = 10.0
        let fetchedResults = retrieveDarkMode()
        if fetchedResults.count > 0 {
            if let darkmode = fetchedResults[0].value(forKey:"isDarkMode") as? Bool{
                if darkmode == true {
                        // for darkMode
                       self.view.backgroundColor = UIColor(rgb: 0x424841)
                       login.backgroundColor = UIColor(rgb: 0xB9451D)
                       signUp.backgroundColor = UIColor(rgb: 0xB9451D)
                        welcomeLabel.textColor = UIColor(rgb: 0xFFFFFF)
                    } else {
                        // for light mode
                       self.view.backgroundColor = UIColor(rgb: 0xFFFBD4)
                        self.login.backgroundColor = UIColor(rgb: 0xFF7738)
                        self.signUp.backgroundColor = UIColor(rgb: 0xFF7738)
                        self.welcomeLabel.textColor = UIColor(rgb: 0x000000)

                    }
            }
            
            
        }
    }
    
    func switchToDarkMode() {}
}

