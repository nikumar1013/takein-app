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
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    @IBAction func setTheDistance(_ sender: Any) {
    }
    
}
