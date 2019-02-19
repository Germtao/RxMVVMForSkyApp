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
    var sessionDataTask = MockURLSessionDataTask()
    
    func dataTask(with request: URLRequest, completionHandler: @escaping MockURLSession.dataTaskHandler) -> URLSessionDataTaskProtocol {
        return sessionDataTask
    }
}
