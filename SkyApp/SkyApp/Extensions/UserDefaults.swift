//
//  UserDefaults.swift
//  SkyApp
//
//  Created by TT on 2019/2/25.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import Foundation

enum DateMode: Int {
    case text   // 文字形式
    case digit  // 数字形式
    
    var format: String {
        return self == .text ? "E, dd MMMM" : "EEEEE, MM/dd"
    }
}

enum TemperatureMode: Int {
    case celsius    // 摄氏度
    case fahrenheit // 华氏度
}

struct UserDefaultsKey {
    static let dateMode = "dateMode"
    static let temperatureMode = "temperatureMode"
}

extension UserDefaults {
    static func dateMode() -> DateMode {
        let value = UserDefaults.standard.integer(forKey: UserDefaultsKey.dateMode)
        return DateMode(rawValue: value) ?? DateMode.text
    }
    
    static func setDateMode(to dateMode: DateMode) {
        UserDefaults.standard.set(dateMode.rawValue, forKey: UserDefaultsKey.dateMode)
    }
    
    static func temperatureMode() -> TemperatureMode {
        let value = UserDefaults.standard.integer(forKey: UserDefaultsKey.temperatureMode)
        return TemperatureMode(rawValue: value) ?? TemperatureMode.celsius
    }
    
    static func setTemperatureMode(to temperatureMode: TemperatureMode) {
        UserDefaults.standard.set(temperatureMode.rawValue, forKey: UserDefaultsKey.temperatureMode)
    }
}


