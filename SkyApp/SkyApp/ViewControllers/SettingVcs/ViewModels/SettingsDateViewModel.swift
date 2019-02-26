//
//  SettingsDateViewModel.swift
//  SkyApp
//
//  Created by TT on 2019/2/26.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import UIKit

struct SettingsDateViewModel: SettingsRepresentable {
    let dateMode: DateMode
    
    /// 根据dateMode确定显示文字
    var labelText: String {
        return dateMode == .text ? "Fri, 01 December" : "F, 12/01"
    }
    
    /// cell的显示格式
    var accessory: UITableViewCell.AccessoryType {
        if UserDefaults.dateMode() == dateMode {
            return .checkmark
        } else {
            return .none
        }
    }
}
