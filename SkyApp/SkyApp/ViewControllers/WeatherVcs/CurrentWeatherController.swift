//
//  CurrentWeatherController.swift
//  SkyApp
//
//  Created by TT on 2019/2/20.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import UIKit

protocol CurrentWeatherControllerDelegate: class {
    func locationButtonPressed(controller: CurrentWeatherController)
    func settingButtonPressed(controller: CurrentWeatherController)
}

class CurrentWeatherController: WeatherViewController {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: CurrentWeatherControllerDelegate?
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        delegate?.locationButtonPressed(controller: self)
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        delegate?.settingButtonPressed(controller: self)
    }
    
    var now: WeatherData? {
        didSet {
            // 明确在主线程刷新UI
            DispatchQueue.main.async { self.updateView() }
        }
    }
    
    var location: Location? {
        didSet {
            DispatchQueue.main.async { self.updateView() }
        }
    }
    
    private func updateView() {
        activityIndicator.stopAnimating()
        
        if let now = now, let location = location {
            updateWeatherContainerView(with: now, at: location)
        } else {
            loadingFailedLabel.isHidden = false
            locationLabel.text = "获取天气位置信息失败"
        }
    }
    
    private func updateWeatherContainerView(with data: WeatherData, at location: Location) {
        weatherContainerView.isHidden = false
        
        locationLabel.text = location.name
        temperatureLabel.text = String(format: "%0.1f ℃", data.currently.temperature)
        weatherIcon.image = UIImage(named: data.currently.icon)
        humidityLabel.text = String(format: "%0.1f", data.currently.humidity)
        summaryLabel.text = data.currently.summary
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMMM"
        dateLabel.text = formatter.string(from: data.currently.time)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
