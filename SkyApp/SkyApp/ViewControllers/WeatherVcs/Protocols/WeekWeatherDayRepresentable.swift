//
//  WeekWeatherDayRepresentable.swift
//  SkyApp
//
//  Created by TT on 2019/2/26.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import UIKit

protocol WeekWeatherDayRepresentable {
    var week: String { get }
    var date: String { get }
    var temperature: String { get }
    var weatherIcon: UIImage? { get }
    var humidity: String { get }
}
