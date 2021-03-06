//
//  WeatherData.swift
//  SkyApp
//
//  Created by TT on 2019/2/19.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import Foundation

/// 表示天气数据, 遵从Codable为了使 json和model 自动s转换
struct WeatherData: Codable {
    let latitude: Double
    let longitude: Double
    let currently: CurrentWeather
    let daily: WeekWeather
    
    struct CurrentWeather: Codable {
        let time: Date
        let summary: String
        let icon: String
        let temperature: Double
        let humidity: Double
    }
    
    struct WeekWeather: Codable {
        let data: [ForecastData]
    }
    
    static let empty = WeatherData(latitude: 0,
                                   longitude: 0,
                                   currently: CurrentWeather(time: Date.from(string: "1970-01-01"), // 期望是一个固定值
                                                             summary: "",
                                                             icon: "",
                                                             temperature: 0,
                                                             humidity: 0),
                                   daily: WeekWeather(data: []))
    
    static let invalid = WeatherData(latitude: 0,
                                     longitude: 0,
                                     currently: CurrentWeather(time: Date.from(string: "1970-01-01"),
                                                               summary: "n/a",
                                                               icon: "n/a",
                                                               temperature: -274,
                                                               humidity: -1),
                                     daily: WeekWeather(data: []))
}

extension WeatherData.CurrentWeather: Equatable {
    static func ==(lhs: WeatherData.CurrentWeather, rhs: WeatherData.CurrentWeather) -> Bool {
        return lhs.time == rhs.time &&
            lhs.summary == rhs.summary &&
            lhs.icon == rhs.icon &&
            lhs.temperature == rhs.temperature &&
            lhs.humidity == rhs.humidity
    }
}

extension WeatherData: Equatable {
    static func ==(lhs: WeatherData, rhs: WeatherData) -> Bool {
        return lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude &&
            lhs.currently == rhs.currently &&
            lhs.daily == rhs.daily
    }
}

extension WeatherData.WeekWeather: Equatable {
    static func ==(lhs: WeatherData.WeekWeather, rhs: WeatherData.WeekWeather) -> Bool {
        return lhs.data == rhs.data
    }
}
