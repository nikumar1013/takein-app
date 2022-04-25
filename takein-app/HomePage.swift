//
//  ViewController.swift
//  takein-app
//
//  Created by Nikhil Kumar on 3/15/22.
//

import UIKit
import CoreData

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

func getUserName() -> String?{
    let fetchedResults: [NSManagedObject] = retrieveUserName()
    if fetchedResults.count < 1 {
        return nil
    }
    if let fetchedUserName = fetchedResults[fetchedResults.count-1].value(forKey: "userName") as? String {
        return fetchedUserName
    }
    return nil
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
}

