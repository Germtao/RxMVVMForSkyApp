//
//  AddLocationViewController.swift
//  SkyApp
//
//  Created by QDSG on 2019/3/4.
//  Copyright © 2019 SwifterTT. All rights reserved.
//

import UIKit
import CoreLocation

protocol AddLocationViewControllerDelegate {
    func controller(_ controller: AddLocationViewController, didAddLocation location: Location)
}

class AddLocationViewController: UITableViewController {
    
    var delegate: AddLocationViewControllerDelegate?
    @IBOutlet weak var searchBar: UISearchBar!
    private lazy var locations = [Location]()
    private lazy var geocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 显示键盘
        searchBar.becomeFirstResponder()
    }

}

// MARK: - UITableViewDataSource
extension AddLocationViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationsViewCell.reuseIdentifier, for: indexPath) as? LocationsViewCell else {
            fatalError("Unexpected table view cell")
        }
        
        let location = locations[indexPath.row]
        let vm = LocationViewModel(location: location.location, locationText: location.name)
        cell.configure(with: vm)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AddLocationViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        delegate?.controller(self, didAddLocation: location)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension AddLocationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        geocode(address: searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        locations.removeAll()
        tableView.reloadData()
    }
    
    /// Helpers
    private func geocode(address: String?) {
        guard let address = address else {
            locations.removeAll()
            tableView.reloadData()
            return
        }
        
        geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            DispatchQueue.main.async {
                self?.processResponse(with: placemarks, error: error)
            }
        }
    }
    
    /// 处理解析结果
    private func processResponse(with placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Cannot handle Geocode Address! \(error)")
        } else if let results = placemarks {
            locations = results.compactMap({ (result) -> Location? in
                guard let name = result.name else { return nil }
                guard let location = result.location else { return nil }
                
                return Location(name: name,
                                latitude: location.coordinate.latitude,
                                longitude: location.coordinate.longitude)
            })
            
            tableView.reloadData()
        }
    }
}
