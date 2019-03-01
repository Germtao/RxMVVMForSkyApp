//
//  WeekWeatherViewModelTests.swift
//  SkyAppTests
//
//  Created by QDSG on 2019/3/1.
//  Copyright © 2019 SwifterTT. All rights reserved.
//

import XCTest
@testable import SkyApp

class WeekWeatherViewModelTests: XCTestCase {
    var vm: WeekWeatherViewModel!

    override func setUp() {
        let data = loadDataFromBundle(of: "DarkSky", ext: "json")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let weatherData = try! decoder.decode(WeatherData.self, from: data)
        
        vm = WeekWeatherViewModel(weatherDatas: weatherData.daily.data)
    }

    override func tearDown() {
        vm = nil
    }

    func test_number_of_sections() {
        XCTAssertEqual(vm.numberOfSections, 1)
    }
    
    func test_number_of_rows() {
        XCTAssertEqual(vm.numberOfDays, 1)
    }
    
    func test_view_model_for_index() {
        let viewModel = vm.viewModel(for: 0)
        
        XCTAssertEqual(viewModel.date, "October 5")
        XCTAssertEqual(viewModel.week, "Thursday")
    }

}
