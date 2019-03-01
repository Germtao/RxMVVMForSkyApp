//
//  WeekWeatherDayViewModelTests.swift
//  SkyAppTests
//
//  Created by QDSG on 2019/3/1.
//  Copyright © 2019 SwifterTT. All rights reserved.
//

import XCTest
@testable import SkyApp

class WeekWeatherDayViewModelTests: XCTestCase {
    var vm: WeekWeatherDayViewModel!

    override func setUp() {
        let data = loadDataFromBundle(of: "DarkSky", ext: "json")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let weatherData = try! decoder.decode(WeatherData.self, from: data)
        
        vm = WeekWeatherDayViewModel(weatherData: weatherData.daily.data[0])
    }

    override func tearDown() {
        vm = nil
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.dateMode)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.temperatureMode)
    }

    func test_date_display() {
        XCTAssertEqual(vm.date, "October 5")
    }

    func test_week_display() {
        XCTAssertEqual(vm.week, "Thursday")
    }
    
    func test_temperature_display_in_celsius() {
        UserDefaults.standard.set(TemperatureMode.celsius.rawValue, forKey: UserDefaultsKey.temperatureMode)
        XCTAssertEqual(vm.temperature, "19 °C - 28 °C")
    }
    
    func test_temperature_display_in_fahrenheit() {
        UserDefaults.standard.set(TemperatureMode.fahrenheit.rawValue, forKey: UserDefaultsKey.temperatureMode)
        XCTAssertEqual(vm.temperature, "66 °F - 82 °F")
    }
    
    func test_humidity() {
        XCTAssertEqual(vm.humidity, "25 %")
    }
    
    func test_weather_icon_dispaly() {
        let iconFromVM = vm.weatherIcon!.pngData()! as NSData
        let iconFromJson = UIImage(named: "clear-day")!.pngData()! as NSData
        
        XCTAssertEqual(vm.weatherIcon!.size.width, 108.0)
        XCTAssertEqual(vm.weatherIcon!.size.height, 108.0)
        XCTAssertEqual(iconFromVM, iconFromJson)
    }
}
