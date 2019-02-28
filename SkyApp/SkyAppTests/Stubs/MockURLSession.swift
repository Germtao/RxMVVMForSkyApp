//
//  MockURLSession.swift
//  SkyAppTests
//
//  Created by TT on 2019/2/19.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import Foundation
@testable import SkyApp

class MockURLSession: URLSessionProtocol {
    var responseData: Data?
    var responseHeader: HTTPURLResponse?
    var responseError: Error?
    
    var sessionDataTask = MockURLSessionDataTask()
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol {
        // 直接调用dataTask的回调函数就好了。这样，就把一个异步回调方法，在测试的过程中变成了一个同步方法
        completionHandler(responseData, responseHeader, responseError)
        return sessionDataTask
    }
}
