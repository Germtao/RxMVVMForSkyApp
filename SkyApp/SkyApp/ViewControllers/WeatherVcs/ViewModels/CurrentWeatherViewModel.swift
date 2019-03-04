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
    
    var weather: WeatherData
    
    static let empty = CurrentWeatherViewModel(weather: WeatherData.empty)
    
    var isEmpty: Bool {
        return self.weather == WeatherData.empty
    }
    
    var temperature: String {
        let value = weather.currently.temperature
        switch UserDefaults.temperatureMode() {
        case .fahrenheit:
            return String(format: "%0.1f °F", value)
        case .celsius:
            return String(format: "%0.1f °C", value.toCelcius())
        }
    }
    
    var humidity: String {
        return String(format: "%0.1f %%", weather.currently.humidity * 100)
    }
    
    var summary: String {
        return weather.currently.summary
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = UserDefaults.dateMode().format
        return formatter.string(from: weather.currently.time)
    }
    
    var weatherIcon: UIImage {
        return UIImage.weatherIcon(of: weather.currently.icon)!
    }
}
