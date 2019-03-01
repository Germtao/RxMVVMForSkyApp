//
//  XCTestCase.swift
//  SkyAppTests
//
//  Created by QDSG on 2019/2/28.
//  Copyright © 2019 SwifterTT. All rights reserved.
//

import XCTest

extension XCTestCase {
    func loadDataFromBundle(of name: String, ext: String) -> Data {
        // 由于不在main.bundle中, 需要获取对应的测试用例类的类名
        let pClass = type(of: self)
        let bundle = Bundle(for: pClass)
        let url = bundle.url(forResource: name, withExtension: ext)
        
        return try! Data(contentsOf: url!)
    }
}
