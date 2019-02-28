//
//  MockURLSessionDataTask.swift
//  SkyAppTests
//
//  Created by TT on 2019/2/19.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import Foundation
@testable import SkyApp

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    /// 判断resume()方法是否被调用了
    private (set) var isResumeCalled = false
    
    func resume() {
        self.isResumeCalled = true
    }
}
