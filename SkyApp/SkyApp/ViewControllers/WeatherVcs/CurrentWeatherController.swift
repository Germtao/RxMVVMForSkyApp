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
    
    @IBOutlet weak var retryBtn: UIButton!
    
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
        let combined =
            Observable.combineLatest(locationVM, weatherVM) {
                return ($0, $1)
            }
            .share(replay: 1, scope: .whileConnected)
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
        
        let viewModel = combined
            .filter { // 筛选一下过滤的结果，要求它们的事件值都不为“空”
                self.shouldDisplayWeatherContainer(locationVM: $0.0, weatherVM: $0.1)
            }
            .asDriver(onErrorJustReturn: (CurrentLocationViewModel.empty, CurrentWeatherViewModel.empty))
        
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
        
        combined.map {
                self.shouldHideActivityIndicator(locationVM: $0.0, weatherVM: $0.1)
            }
            .asDriver(onErrorJustReturn: false)
            .drive(activityIndicator.rx.isHidden).disposed(by: bag)
        
        combined.map {
            self.shouldAnimateActivityIndicator(locationVM: $0.0, weatherVM: $0.1)
            }.asDriver(onErrorJustReturn: true)
            .drive(activityIndicator.rx.isAnimating).disposed(by: bag)
        
        combined.map {
                self.shouldHideWeatherContainer(locationVM: $0.0, weatherVM: $0.1)
            }
            .asDriver(onErrorJustReturn: true)
            .drive(weatherContainerView.rx.isHidden).disposed(by: bag)
        
        
        let errorCon = combined.map {
            self.shouldDisplayErrorPrompt(locationVM: $0.0, weatherVM: $0.1)
        }.asDriver(onErrorJustReturn: true)

        errorCon.map { !$0 }.drive(self.retryBtn.rx.isHidden).disposed(by: bag)
        errorCon.map { !$0 }.drive(loadingFailedLabel.rx.isHidden).disposed(by: bag)
        errorCon.map { _ in return "ok" }.drive(loadingFailedLabel.rx.text).disposed(by: bag)
        
        // 处理Retry按钮
        self.retryBtn.rx.tap.subscribe(onNext: { _ in
            self.weatherVM.accept(.empty)
            self.locationVM.accept(.empty)
            
            (self.parent as? RootViewController)?.fetchCity()
            (self.parent as? RootViewController)?.fetchWeather()
        }).disposed(by: bag)
    }
    
    /**
     总结:
         1. .drive - 更加侧重于表达viewModel驱动了某些元素变化这样的概念, 更加侧重于 表达过程
         2. .bind  - 更侧重于表达把 viewModel 绑定到某些元素, 更侧重于 表达关系
         3. 专注于 Observable 和 .subscribe, 忽略以上两种方式
     */

}

private extension CurrentWeatherController {
    func shouldDisplayWeatherContainer(locationVM: CurrentLocationViewModel, weatherVM: CurrentWeatherViewModel) -> Bool {
        return !locationVM.isEmpty && !weatherVM.isEmpty && !locationVM.isInvalid && !weatherVM.isInvalid
    }
    
    func shouldHideWeatherContainer(locationVM: CurrentLocationViewModel, weatherVM: CurrentWeatherViewModel) -> Bool {
        return locationVM.isEmpty || locationVM.isInvalid || weatherVM.isEmpty || weatherVM.isInvalid
    }
    
    func shouldHideActivityIndicator(locationVM: CurrentLocationViewModel, weatherVM: CurrentWeatherViewModel) -> Bool {
        return (!locationVM.isEmpty && !weatherVM.isEmpty) || locationVM.isInvalid || weatherVM.isInvalid
    }
    
    func shouldAnimateActivityIndicator(locationVM: CurrentLocationViewModel, weatherVM: CurrentWeatherViewModel) -> Bool {
        return locationVM.isEmpty || weatherVM.isEmpty
    }
    
    /// 处理错误条件下的交互
    func shouldDisplayErrorPrompt(locationVM: CurrentLocationViewModel, weatherVM: CurrentWeatherViewModel) -> Bool {
        return locationVM.isInvalid || weatherVM.isInvalid
    }
}
