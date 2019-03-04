//
//  Location.swift
//  SkyApp
//
//  Created by TT on 2019/2/19.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import Foundation
import CoreLocation

/// 表示当前位置和地区名称
struct Location: Equatable {
    var name: String
    /// 纬度
    var latitude: Double
    /// 经度
    var longitude: Double
    
    private struct Keys {
        static let name = "name"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init?(from dict: [String: Any]) {
        guard let name = dict[Keys.name] as? String else { return nil }
        guard let latitude = dict[Keys.latitude] as? Double else { return nil }
        guard let longitude = dict[Keys.longitude] as? Double else { return nil }
        
        self.init(name: name, latitude: latitude, longitude: longitude)
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var toDictionary: [String: Any] {
        return ["name": name, "latitude": latitude, "longitude": longitude]
    }
}
