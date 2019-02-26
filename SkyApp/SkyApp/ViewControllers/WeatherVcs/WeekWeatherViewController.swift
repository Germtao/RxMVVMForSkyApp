//
//  WeekWeatherViewController.swift
//  SkyApp
//
//  Created by TT on 2019/2/22.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import UIKit

class WeekWeatherViewController: WeatherViewController {
    
    @IBOutlet weak var weekWeatherTableView: UITableView!
    
    var viewModel: WeekWeatherViewModel? {
        didSet {
            DispatchQueue.main.async { self.updateView() }
        }
    }
    
    func updateView() {
        activityIndicator.stopAnimating()
        
        if let _ = viewModel {
            updateWeekWeatherContainer()
        } else {
            loadingFailedLabel.isHidden = false
            loadingFailedLabel.text = "获取位置天气信息错误"
        }
    }
    
    func updateWeekWeatherContainer() {
        weatherContainerView.isHidden = false
        weekWeatherTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension WeekWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfDays
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: WeekWeatherTableViewCell.reuseIdentifier, for: indexPath) as? WeekWeatherTableViewCell
        
        guard let row = cell else {
            fatalError("Unexpected table view cell")
        }
        
        if let weatherDay = viewModel?.viewModel(for: indexPath.row) {
            row.configure(with: weatherDay)
        }
        
        return row
    }
}
