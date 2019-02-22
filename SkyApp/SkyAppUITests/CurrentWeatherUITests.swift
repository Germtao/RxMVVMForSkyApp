//
//  CurrentWeatherUITests.swift
//  SkyAppUITests
//
//  Created by TT on 2019/2/21.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import XCTest

class CurrentWeatherUITests: XCTestCase {
    
    /// 需要一个表示正在执行的App的对象
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        // 设置app执行环境
        app.launchArguments += ["UI-TESTING"]  // 执行参数
        let json = """
        {
            "longitude" : 100,
            "latitude" : 52,
            "currently" : {
                "temperature" : 23,
                "humidity" : 0.91,
                "icon" : "snow",
                "time" : 1507180335,
                "summary" : "Light Snow"
            }
        }
        """
        app.launchEnvironment["FakeJSON"] = json  // 执行环境
        
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        super.tearDown()
    }

    // MARK: - 等待异步加载UI
    func test_location_button_exists() {
        let locationBtn = app.buttons["LocationBtn"]
        XCTAssert(locationBtn.exists)
    }
    
    func test_currently_weather_display() {
        XCTAssert(app.images["snow"].exists)
        XCTAssert(app.staticTexts["Light Snow"].exists)
    }

}
