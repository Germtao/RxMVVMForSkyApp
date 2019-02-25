//
//  WeekWeatherViewModel.swift
//  SkyApp
//
//  Created by TT on 2019/2/25.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import UIKit

struct WeekWeatherViewModel {
    let weatherDatas: [ForecastData]
    
    private let dateFormatter = DateFormatter()
    
    func week(for index: Int) -> String {
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: weatherDatas[index].time)
    }
    
    func date(for index: Int) -> String {
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: weatherDatas[index].time)
    }
    
    func temperature(for index: Int) -> String {
        let min = format(temperature: weatherDatas[index].temperatureLow)
        let max = format(temperature: weatherDatas[index].temperatureHigh)
        return "\(min) - \(max)"
    }
    
    func weatherIcon(for index: Int) -> UIImage? {
        return UIImage.weatherIcon(of: weatherDatas[index].icon)
    }
    
    func humidity(for index: Int) -> String {
        return String(format: "%.0f %%", weatherDatas[index].humidity)
    }
    
    // Controller不应该直接与Model进行任何交互。
    // 因此，WeekWeatherViewModel还应该为Controller提供UITableViewDataSource需要的数据
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfDays: Int {
        return weatherDatas.count
    }
    
    // MARK: - Helper
    func format(temperature: Double) -> String {
        switch UserDefaults.temperatureMode() {
        case .celsius:
            return String(format: "%.0f °C", temperature.toCelcius())
        case .fahrenheit:
            return String(format: "%.0f °F", temperature)
        }
    }
}
