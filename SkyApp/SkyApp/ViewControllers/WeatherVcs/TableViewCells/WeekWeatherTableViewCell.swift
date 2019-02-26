//
//  WeekWeatherTableViewCell.swift
//  SkyApp
//
//  Created by TT on 2019/2/22.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import UIKit

class WeekWeatherTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "weekWeatherCell"
    
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with vm: WeekWeatherDayRepresentable) {
        weekLabel.text = vm.week
        dateLabel.text = vm.date
        temperatureLabel.text = vm.temperature
        weatherIconView.image = vm.weatherIcon
        humidityLabel.text = vm.humidity
    }

}
