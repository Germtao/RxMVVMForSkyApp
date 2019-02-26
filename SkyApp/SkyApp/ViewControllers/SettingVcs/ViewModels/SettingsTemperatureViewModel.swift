//
//  SettingsTemperatureViewModel.swift
//  SkyApp
//
//  Created by TT on 2019/2/26.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import UIKit

struct SettingsTemperatureViewModel: SettingsRepresentable {
    let temperatureMode: TemperatureMode
    
    var labelText: String {
        return temperatureMode == .celsius ? "Celsius" : "Fahrenhait"
    }
    
    var accessory: UITableViewCell.AccessoryType {
        if UserDefaults.temperatureMode() == temperatureMode {
            return .checkmark
        } else {
            return .none
        }
    }
}
