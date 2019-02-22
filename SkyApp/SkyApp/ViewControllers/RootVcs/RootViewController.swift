//
//  RootViewController.swift
//  SkyApp
//
//  Created by TT on 2019/2/18.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import UIKit
import CoreLocation

class RootViewController: UIViewController {
    
    private let segueCurrentWeather = "SegueCurrentWeather"
    var currentWeatherVc: CurrentWeatherController!
    
    /// ViewControllers之间传递数据
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case segueCurrentWeather:
            guard let destination = segue.destination as? CurrentWeatherController else {
                fatalError("Invalid destination view controller!")
            }
            
            destination.delegate = self
            destination.viewModel = CurrentWeatherViewModel()
            currentWeatherVc = destination
            
        default:
            break
        }
    }
    
    /// 存储用户当前定位
    private var currentLocation: CLLocation? {
        didSet {
            // 定位成功后, 继续获取位置名称和天气信息
            fetchCity()
            fetchWeather()
        }
    }
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.distanceFilter = 1000
        manager.desiredAccuracy = 1000
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // App每次进入活跃状态的这个事件。这时，我们就要尝试获取用户地理位置，并更新当前天气
        setupActiveNotification()
    }
    
    /// 请求位置
    private func requestLocation() {
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    /// 获取天气
    private func fetchWeather() {
        guard let currentLocation = currentLocation else { return }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        WeatherDataManager.shared.weatherDataAt(latitude: lat, longitude: lon) { (response, error) in
            if let error = error {
                dump(error)
            } else if let response = response {
                self.currentWeatherVc.viewModel?.weather = response
            }
        }
    }
    
    // MARK: - Todo: 获取城市
    private func fetchCity() {
        guard let currentLocation = currentLocation else { return }
        
        // 解析位置名称
        CLGeocoder().reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if let error = error {
                dump(error)
            } else if let city = placemarks?.first?.locality {
                let location = Location(
                    name: city,
                    latitude: currentLocation.coordinate.latitude,
                    longitude: currentLocation.coordinate.longitude)
                self.currentWeatherVc.viewModel?.location = location
            }
        }
    }
    
    @objc func applicationDidBecomeActive(_ noti: Notification) {
        requestLocation()
    }
    
    private func setupActiveNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive(_:)),
            name: UIApplication.didBecomeActiveNotification, object: nil)
    }

}

extension RootViewController: CLLocationManagerDelegate {
    /// 位置发生变化时调用
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            
            // 定位完成后, 停止定位
            manager.delegate = nil
            manager.stopUpdatingLocation()
        }
    }
    
    /// 权限发生变化时调用
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            requestLocation()
        }
    }
    
    /// 定位错误
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        dump(error)
    }
}

extension RootViewController: CurrentWeatherControllerDelegate {
    func locationButtonPressed(controller: CurrentWeatherController) {
        print("Open Locations")
    }
    
    func settingButtonPressed(controller: CurrentWeatherController) {
        print("Open Settting")
    }
    
    
}
