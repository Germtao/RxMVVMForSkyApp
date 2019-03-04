//
//  CurrentWeatherController.swift
//  SkyApp
//
//  Created by TT on 2019/2/20.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
    
    private var bag = DisposeBag()
    
    var weatherVM: BehaviorRelay<CurrentWeatherViewModel> = BehaviorRelay(value: CurrentWeatherViewModel.empty)
    var locationVM: BehaviorRelay<CurrentLocationViewModel> = BehaviorRelay(value: CurrentLocationViewModel.empty)
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        delegate?.locationButtonPressed(controller: self)
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        delegate?.settingButtonPressed(controller: self)
    }
    
    func updateView() {
        weatherVM.accept(weatherVM.value)
        locationVM.accept(locationVM.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 合并出一个包含weatherVM和locationVM事件值的Observable
        Observable.combineLatest(locationVM, weatherVM) {
            return ($0, $1)
            }
            .filter { // 筛选一下过滤的结果，要求它们的事件值都不为“空”
                let (location, weather) = $0
                return !location.isEmpty && !weather.isEmpty
            }
            .observeOn(MainScheduler.instance) // 确保订阅者在主线程上执行代码
            .subscribe(onNext: { [unowned self] in
                let (location, weather) = $0
                
                self.weatherContainerView.isHidden = false
                self.locationLabel.text = location.city
                
                self.temperatureLabel.text = weather.temperature
                self.weatherIcon.image = weather.weatherIcon
                self.humidityLabel.text = weather.humidity
                self.summaryLabel.text = weather.summary
                self.dateLabel.text = weather.date
            }).disposed(by: bag)
    }

}
