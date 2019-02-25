//
//  ForecastData.swift
//  SkyApp
//
//  Created by TT on 2019/2/25.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import Foundation

// Codable - 为了支持JSON到Model的自动转换
struct ForecastData: Codable {
    let time: Date
    let temperatureLow: Double
    let temperatureHigh: Double
    let icon: String
    let humidity: Double
}

// MARK: - 为了通过单元测试，我们首先得让ForecastData支持相等比较
extension ForecastData: Equatable {
    static func ==(lhs: ForecastData, rhs: ForecastData) -> Bool {
        return lhs.time == rhs.time &&
            lhs.temperatureLow == rhs.temperatureLow &&
            lhs.temperatureHigh == rhs.temperatureHigh &&
            lhs.icon == rhs.icon &&
            lhs.humidity == rhs.humidity
    }
}
