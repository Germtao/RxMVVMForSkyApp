//
//  LocationsViewController.swift
//  SkyApp
//
//  Created by QDSG on 2019/3/4.
//  Copyright © 2019 SwifterTT. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationsViewControllerDelegate {
    func controller(_ controller: LocationsViewController, didSelectLocation location: CLLocation)
}

class LocationsViewController: UITableViewController {
    
    var delegate: LocationsViewControllerDelegate?
    var currentLocation: CLLocation?
    var favourites = UserDefaults.loadLocations()
    
    private var hasFavourites: Bool {
        return favourites.count > 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

}

// MARK: - UITableViewDataSource
extension LocationsViewController {
    private enum Section: Int {
        case current
        case favourite
        
        var title: String {
            switch self {
            case .current:
                return "Current Location"
            case .favourite:
                return "Favourite Location"
            }
        }
        
        static var count: Int {
            return Section.favourite.rawValue + 1
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { fatalError("Unexpected section") }
        
        switch section {
        case .current:
            return 1
        case .favourite:
            return max(favourites.count, 1)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Unexpected section") }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationsViewCell.reuseIdentifier, for: indexPath) as? LocationsViewCell else {
            fatalError("Unexpected cell")
        }
        
        var vm: LocationViewModel?
        
        switch section {
        case .current:
            if let currentLocation = currentLocation {
                vm = LocationViewModel(location: currentLocation, locationText: nil)
            } else {
                cell.label.text = "Current Location Unknow"
            }
        case .favourite:
            if favourites.count > 0 {
                let fav = favourites[indexPath.row]
                vm = LocationViewModel(location: fav.location, locationText: fav.name)
            } else {
                cell.label.text = "No Favourites Yet..."
            }
        }
        
        if let vm = vm {
            cell.configure(with: vm)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Unexpected section") }
        
        switch section {
        case .current:
            return false
        case .favourite:
            return hasFavourites
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let location = favourites[indexPath.row]
        UserDefaults.removeLocation(location)
        
        favourites.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else { fatalError("Unexpected section") }
        return section.title
    }
}

// MARK: - UITableViewDelegate
extension LocationsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Unexpected Section") }
        
        var location: CLLocation?
        
        switch section {
        case .current:
            if let currentLocation = currentLocation {
                location = currentLocation
            }
        case .favourite:
            if hasFavourites {
                location = favourites[indexPath.row].location
            }
        }
        
        if location != nil {
            delegate?.controller(self, didSelectLocation: location!)
            dismiss(animated: true, completion: nil)
        }
    }
}
