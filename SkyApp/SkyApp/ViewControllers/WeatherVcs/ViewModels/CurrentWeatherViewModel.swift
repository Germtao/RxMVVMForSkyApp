//
//  CurrentWeatherViewModel.swift
//  SkyApp
//
//  Created by TT on 2019/2/21.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import UIKit

/// 主要作用: 就是要把Model和Controller隔离, 它应该为Controller提供所有数据访问的接口
struct CurrentWeatherViewModel {
    // 加几个属性，用于在Controller中标记更新状态
    var isLocationReady = false
    var isWeatherReady = false
    var isUpdateReady: Bool {
        return isLocationReady && isWeatherReady
    }
    
    var location: Location! {
        didSet {
            self.isLocationReady = location != nil ? true : false
        }
    }
    var weather: WeatherData! {
        didSet {
            self.isWeatherReady = weather != nil ? true : false
        }
    }
    
    var city: String {
        return location.name
    }
    
    var temperature: String {
        return String(format: "%0.1f ℃", weather.currently.temperature)
    }
    
    var humidity: String {
        return String(format: "%0.1f %%", weather.currently.humidity * 100)
    }
    
    var summary: String {
        return weather.currently.summary
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMMM"
        return formatter.string(from: weather.currently.time)
    }
    
    var weatherIcon: UIImage {
        return UIImage.weatherIcon(of: weather.currently.icon)!
    }
}
