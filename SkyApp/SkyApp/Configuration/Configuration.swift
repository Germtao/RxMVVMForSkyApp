//
//  Configuration.swift
//  SkyApp
//
//  Created by TT on 2019/2/19.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

// MARK: - 第三方服务配置
import Foundation

struct API {
    static let key = "05dab4e3bbb42d5f5de793f65238d9b4"
    static let baseURL = URL(string: "https://api.darksky.net/forecast")!
    static let authenticatedURL = baseURL.appendingPathComponent(key)
}
