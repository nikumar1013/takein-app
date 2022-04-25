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
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        eventTable.delegate = self
        eventTable.dataSource = self
        eventTable.layer.cornerRadius = 10
        eventTable.rowHeight = 125
        
        // sets the switch to what the user settings currently are
        if isLight == nil {
            if self.traitCollection.userInterfaceStyle == .dark {
                overrideUserInterfaceStyle = .dark
                isLight = false
            } else {
                overrideUserInterfaceStyle = .light
                isLight = true
            }
        } else {
            if isLight == true {
                overrideUserInterfaceStyle = .light
            } else {
                overrideUserInterfaceStyle = .dark
            }
        }
        
        eventTable.backgroundColor =  UIColor(named: "tableViewColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        if isLight == true {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }
        
        eventTable.backgroundColor =  UIColor(named: "tableViewColor")
        self.view.backgroundColor = UIColor(named: "BackgroundColor" )
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        let controller = UIAlertController(
            title: "Filters",
            message: "Select from the filters below",
            preferredStyle: .actionSheet)
        let radius = UIAlertAction(title: "Radius", style: .default, handler: nil)
        controller.addAction(radius)
        present(controller, animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as! ExploreViewCell
        cell.contentView.backgroundColor = UIColor(named: "tableViewColor")
        return cell
    }
    
}
