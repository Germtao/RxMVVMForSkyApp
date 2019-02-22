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
        
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        super.tearDown()
    }

    // MARK: - 等待异步加载UI
    func test_location_button_exists() {
        let locationBtn = app.buttons["LocationBtn"]
        let exists = NSPredicate(format: "exists == true")

        expectation(for: exists, evaluatedWith: locationBtn, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssert(locationBtn.exists)
    }

}
