//
//  Date.swift
//  SkyApp
//
//  Created by QDSG on 2019/3/8.
//  Copyright © 2019 SwifterTT. All rights reserved.
//

import Foundation

extension Date {
    static func from(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+8:00")
        return dateFormatter.date(from: string)!
    }
}
