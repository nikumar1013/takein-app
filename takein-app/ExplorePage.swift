//
//  ExplorePage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit
import MapKit

class ExplorePage: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var explorePageMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        let controller = UIAlertController(
            title: "Filters",
            message: "Select from the filters below",
            preferredStyle: .actionSheet)
        
        let radius = UIAlertAction(title: "Radius", style: .default, handler: nil)
        controller.addAction(radius)
        
        present(controller, animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
