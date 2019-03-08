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
        let viewModel =
            Observable.combineLatest(locationVM, weatherVM) {
                return ($0, $1)
            }
            .filter { // 筛选一下过滤的结果，要求它们的事件值都不为“空”
                let (location, weather) = $0
                return !location.isEmpty && !weather.isEmpty
            }
            .share(replay: 1, scope: .whileConnected)
            .asDriver(onErrorJustReturn: (CurrentLocationViewModel.empty, CurrentWeatherViewModel.empty))
        /**
         .asDriver 代替 .observeOn
         
         Driver: 它就是一个定制过的 Observable, 拥有以下特性:
             1. 确保在主线程中订阅, 这样也就保证了事件发生后的订阅代码也一定会在主线程中执行
             2. 不会发生.error事件, 无需再“订阅”一个Driver的时候, 想着处理错误事件的情况. 正是由于这个约束, asDriver方法有一个 onErrorJustReturn 参数, 要求我们指定发生错误生成的事件.
                返回了(CurrentLocationViewModel.empty, CurrentWeatherViewModel.empty)), 在任何情况, 都可以用统一的代码来处理用户交互了.
         */
        
//            .observeOn(MainScheduler.instance) // 确保订阅者在主线程上执行代码
//            .subscribe(onNext: { [unowned self] in
//                let (location, weather) = $0
//
//                self.weatherContainerView.isHidden = false
//                self.locationLabel.text = location.city
//
//                self.temperatureLabel.text = weather.temperature
//                self.weatherIcon.image = weather.weatherIcon
//                self.humidityLabel.text = weather.humidity
//                self.summaryLabel.text = weather.summary
//                self.dateLabel.text = weather.date
//            }).disposed(by: bag)
        
        viewModel.map { $0.0.city }
            .drive(locationLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.temperature }
            .drive(temperatureLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.weatherIcon }
            .drive(weatherIcon.rx.image).disposed(by: bag)
        viewModel.map { $0.1.humidity }
            .drive(humidityLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.summary }
            .drive(summaryLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.date }
            .drive(dateLabel.rx.text).disposed(by: bag)
        
        viewModel.map { _ in false }
            .drive(activityIndicator.rx.isAnimating).disposed(by: bag)
        viewModel.map { _ in false }
            .drive(weatherContainerView.rx.isHidden).disposed(by: bag)
    }
    
    /**
     总结:
         1. .drive - 更加侧重于表达viewModel驱动了某些元素变化这样的概念, 更加侧重于 表达过程
         2. .bind  - 更侧重于表达把 viewModel 绑定到某些元素, 更侧重于 表达关系
         3. 专注于 Observable 和 .subscribe, 忽略以上两种方式
     */

}
