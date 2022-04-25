//
//  FilterViewController.swift
//  takein-app
//
//  Created by Pooja Chivukula on 4/18/22.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var distance: UITextField!
    @IBOutlet weak var setButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton.layer.cornerRadius = 10
    }
    
    
    @IBAction func setTheDistance(_ sender: Any) {}
    
}
