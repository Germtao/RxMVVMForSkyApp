//
//  SettingsContent.swift
//  SkyApp
//
//  Created by TT on 2019/2/26.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import UIKit

protocol SettingsRepresentable {
    var labelText: String { get }
    var accessory: UITableViewCell.AccessoryType { get }
}
