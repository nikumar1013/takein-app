//
//  ExplorePage.swift
//  takein-app
//
//  Created by Nick Wille on 3/17/22.
//

import UIKit
import MapKit

class ExploreViewCell: UITableViewCell {
    @IBOutlet weak var event_name: UILabel!
    @IBOutlet weak var event_distance: UILabel!
    @IBOutlet weak var event_date: UILabel!
    @IBOutlet weak var event_image: UIImageView!
}

class ExplorePage: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var eventTable: UITableView!
    @IBOutlet weak var explorePageMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        eventTable.delegate = self
        eventTable.dataSource = self
        eventTable.layer.cornerRadius=10
        // row height is constant in this case (no variable length contents in the cells)
        eventTable.rowHeight = 125
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as! ExploreViewCell

            return cell
    }

}
