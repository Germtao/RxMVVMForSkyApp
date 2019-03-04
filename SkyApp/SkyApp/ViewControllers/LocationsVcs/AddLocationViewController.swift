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
    var viewModel: AddLocationViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddLocationViewModel()
        
        // 设置viewModel的hHooks
        // AddLocationViewModel为class, 使用 [unowned self] 指定self获取方式
        viewModel.locationsDidChange = { [unowned self] locations in
            self.tableView.reloadData()
        }
        
        viewModel.queryingStatusDidChange = { [unowned self] isQuerying in
            if isQuerying {
                self.title = "Searching..."
            } else {
                self.title = "Add a location"
            }
        }
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
        return viewModel.numberOfLocations
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationsViewCell.reuseIdentifier, for: indexPath) as? LocationsViewCell else {
            fatalError("Unexpected table view cell")
        }
        
        if let vm = viewModel.locationViewModel(at: indexPath.row) {
            cell.configure(with: vm)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AddLocationViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let location = viewModel.location(at: indexPath.row) else { return }
        delegate?.controller(self, didAddLocation: location)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension AddLocationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.queryText = searchBar.text ?? ""
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.queryText = searchBar.text ?? ""
    }
}
