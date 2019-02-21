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
    
    var viewModel: CurrentWeatherViewModel? {
        didSet {
            // 明确在主线程刷新UI
            DispatchQueue.main.async { self.updateView() }
        }
    }
    
    private func updateView() {
        activityIndicator.stopAnimating()
        
        if let vm = viewModel, vm.isUpdateReady {
            updateWeatherContainerView(with: vm)
        } else {
            loadingFailedLabel.isHidden = false
            loadingFailedLabel.text = "获取天气位置信息失败"
        }
    }
    
    private func updateWeatherContainerView(with vm: CurrentWeatherViewModel) {
        weatherContainerView.isHidden = false
        
        temperatureLabel.text = vm.temperature
        weatherIcon.image = vm.weatherIcon
        humidityLabel.text = vm.humidity
        summaryLabel.text = vm.summary
        dateLabel.text = vm.date
        locationLabel.text = vm.city
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
