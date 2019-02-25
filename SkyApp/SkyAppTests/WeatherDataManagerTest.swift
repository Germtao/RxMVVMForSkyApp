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
    let url = URL(string: "https://darksky.net")!
    var session: MockURLSession!
    var manager: WeatherDataManager!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        session = MockURLSession()
        manager = WeatherDataManager(baseURL: url, urlSession: session)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - 编写测试用例
    /// 1. 每一个测试用例，应该只测试一个内容，例如：测试resume()方法是否被调用了
    /// 2. 对于不属于我们自己的代码，例如：系统API、第三方框架等，我们要mock掉相关的代码以隔离它们对测试过程的影响
    func test_weatherDataAt_starts_the_session() {
        let dataTask = MockURLSessionDataTask()
        
        session.sessionDataTask = dataTask
        
        manager.weatherDataAt(latitude: 52, longitude: 100) { (_, _) in }
        
        XCTAssert(session.sessionDataTask.isResumeCalled)
    }
    
    /// 确保服务器的返回结果不为nil
    func test_weatherDataAt_gets_data() {
        var data: WeatherData? = nil
        
        // 1. 设置一个"期望", Expectation
        // 问题 - 测试结果仍旧取决于网络状况，因此我们很难保证多次测试结果的一致性
        //     - 当我们要测试一个REST服务的时候，如果每个URL的测试都基于实际网络访问和超时的机制，将会显著增加测试执行的时间
        let expect = expectation(description: "Loading data from \(API.authenticatedURL)")
        WeatherDataManager.shared.weatherDataAt(latitude: 52, longitude: 100) { (response, error) in
            data = response
            expect.fulfill()  // - Notify Xcode here
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(data)
    }
    
    /// 测试可以正确的处理请求错误
    func test_weatherDataAt_handle_invalid_request() {
        session.responseError = NSError(domain: "Invalid Request", code: 100, userInfo: nil)
        var error: WeatherDataError? = nil
        manager.weatherDataAt(latitude: 52, longitude: 100) { (_, err) in
            error = err
        }
        XCTAssertEqual(error, WeatherDataError.failedRequest)
    }
    
    /// 测试可以正确处理服务器返回的状态码
    func test_weatherDataAt_handle_statuscode_not_equalTo_200() {
        session.responseHeader = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        let data = "{}".data(using: .utf8)
        session.responseData = data
        
        var error: WeatherDataError? = nil
        manager.weatherDataAt(latitude: 52, longitude: 100) { (_, err) in
            error = err
        }
        XCTAssertEqual(error, WeatherDataError.failedRequest)
    }
    
    /// 测试服务器返回的内容不正确
    func test_weatherDataAt_handle_invalid_response() {
        session.responseHeader = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        /// Make a invalid JSON response here
        let data = "{".data(using: .utf8)!
        session.responseData = data
        
        var error: WeatherDataError? = nil
        manager.weatherDataAt(latitude: 52, longitude: 100) { (_, err) in
            error = err
        }
        XCTAssertEqual(error, WeatherDataError.invalidResponse)
    }
    
    /// 测试可以正确解码服务器返回值
    func test_weatherDataAt_hanle_response_decode() {
        session.responseHeader = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let data = """
        {
            "longitude": 100,
            "latitude": 52,
            "currently": {
                "temperature": 23,
                "humidity": 0.91,
                "icon": "snow",
                "time": 1507180335,
                "summary": "Light Snow"
                },
            "daily": {
                "data": [
                    {
                        "time": 1507180335,
                        "icon": "clear-day",
                        "temperatureLow": 66,
                        "temperatureHigh": 82,
                        "humidity": 0.25
                    }
                ]
            }
        }
        """.data(using: .utf8)!
        session.responseData = data
        
        var decode: WeatherData? = nil
        
        manager.weatherDataAt(latitude: 52, longitude: 100) { (d, _) in
            decode = d
        }
        
        let expectWeek = WeatherData.WeekWeather(
            data: [ForecastData(
                time: Date(timeIntervalSince1970: 1507180335),
                temperatureLow: 66,
                temperatureHigh: 82,
                icon: "clear-day",
                humidity: 0.25)])
        
        let expect = WeatherData(
            latitude: 52,
            longitude: 100,
            currently: WeatherData.CurrentWeather(
                time: Date(timeIntervalSince1970: 1507180335),
                summary: "Light Snow",
                icon: "snow",
                temperature: 23,
                humidity: 0.91),
            daily: expectWeek)
        
        XCTAssertEqual(decode, expect)
    }
}
