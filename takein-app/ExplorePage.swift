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
    
    func switchToDarkMode() {}
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
        eventTable.rowHeight = 125
        eventTable.backgroundColor = UIColor(rgb: 0xE7E0B8)

        eventTable.backgroundColor =  UIColor(named: "tableViewColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()

        eventTable.backgroundColor =  UIColor(named: "tableViewColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
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
    
    func switchToDarkMode() {}
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as! ExploreViewCell

         cell.contentView.backgroundColor = UIColor(named: "tableViewColor")
            return cell
    }

}
