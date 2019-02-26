//
//  SettingsTableViewCell.swift
//  SkyApp
//
//  Created by TT on 2019/2/25.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "SettingsTableViewCell"
    
    @IBOutlet weak var label: UILabel!

    /// 可以自我配置的cell, 所谓面向protocol编程优雅和简洁的地方
    func configure(vm: SettingsRepresentable) {
        label.text = vm.labelText
        accessoryType = vm.accessory
    }
}
