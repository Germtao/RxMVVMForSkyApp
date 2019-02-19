//
//  WeatherDataManagerTest.swift
//  SkyAppTests
//
//  Created by TT on 2019/2/19.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import XCTest
@testable import SkyApp  // 引入项目的main module, 才能在测试用例中，访问到项目定义的类型

// 进行单元测试的一个重要前提，就是我们要测试的代码是“可测试”的。所谓“可测试”，是指代码的测试要满足一些条件，包括:
// 1. 测试过程要不依赖于任何外部条件和系统
// 2. 在任何环境、测试任意多次，结果应该保持不变

class WeatherDataManagerTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// 编写测试用例
    /// 1. 每一个测试用例，应该只测试一个内容，例如：测试resume()方法是否被调用了
    /// 2. 对于不属于我们自己的代码，例如：系统API、第三方框架等，我们要mock掉相关的代码以隔离它们对测试过程的影响
    func test_weatherDataAt_starts_the_session() {
        let session = MockURLSession()
        let dataTask = MockURLSessionDataTask()
        
        session.sessionDataTask = dataTask
        
        let url = URL(string: "https://darkshy.net")!
        let manager = WeatherDataManager(baseURL: url, urlSession: session)
        
        manager.weatherDataAt(latitude: 52, longitude: 100) { (_, _) in }
        
        XCTAssert(session.sessionDataTask.isResumeCalled)
    }
}
