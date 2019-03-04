//
//  Array.swift
//  SkyApp
//
//  Created by QDSG on 2019/3/4.
//  Copyright © 2019 SwifterTT. All rights reserved.
//

import Foundation

extension Array {
    func index(of e: Any) -> Int? {
        let arr = self as NSArray
        return arr.index(of: e)
    }
}
