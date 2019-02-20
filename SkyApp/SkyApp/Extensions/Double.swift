//
//  Double.swift
//  SkyApp
//
//  Created by TT on 2019/2/20.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import Foundation

extension Double {
    /// 华氏度转摄氏度
    func toCelcius() -> Double {
        return (self - 32.0) / 1.8
    }
}
