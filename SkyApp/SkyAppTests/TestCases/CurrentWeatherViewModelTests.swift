//
//  CurrentWeatherViewModelTests.swift
//  SkyAppTests
//
//  Created by QDSG on 2019/2/28.
//  Copyright © 2019 SwifterTT. All rights reserved.
//

import XCTest
@testable import SkyApp

class CurrentWeatherViewModelTests: XCTestCase {
    var vm: CurrentWeatherViewModel!

    override func setUp() {
        // 1. load data
        let data = loadDataFromBundle(of: "DarkSky", ext: "json")
        
        // 2. decode data
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let weatherData = try! decoder.decode(WeatherData.self, from: data)
        
        // 3. create vm
        vm = CurrentWeatherViewModel()
        vm.location = Location(name: "Test City", latitude: 100, longitude: 100)
        vm.weather = weatherData
    }

    override func tearDown() {
        vm = nil
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.dateMode)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.temperatureMode)
    }

    func test_city_name_display() {
        XCTAssertEqual(vm.city, "Test City")
    }
    
    func test_weather_summary() {
        XCTAssertEqual(vm.summary, "Light Snow")
    }
    
    func test_humidity_display() {
        XCTAssertEqual(vm.humidity, "91.0 %")
    }
    
    func test_date_display_in_text_mode() {
        let mode = DateMode.text
        
        UserDefaults.standard.set(mode.rawValue, forKey: UserDefaultsKey.dateMode)
        XCTAssertEqual(vm.date, "Thu, 05 October")
    }
    
    func test_date_display_in_digit_mode() {
        let mode = DateMode.digit
        
        UserDefaults.standard.set(mode.rawValue, forKey: UserDefaultsKey.dateMode)
        XCTAssertEqual(vm.date, "T, 10/05")
    }
    
    func test_temperature_display_in_celsius_mode() {
        let mode = TemperatureMode.celsius
        
        UserDefaults.standard.set(mode.rawValue, forKey: UserDefaultsKey.temperatureMode)
        XCTAssertEqual(vm.temperature, "-5.0 °C")
    }
    
    func test_temperature_display_in_fahrenheit_mode() {
        let mode = TemperatureMode.fahrenheit
        UserDefaults.standard.set(mode.rawValue, forKey: UserDefaultsKey.temperatureMode)
        XCTAssertEqual(vm.temperature, "23.0 °F")
    }
    
    /// 比对View Model中的图片，和直接通过DarkSky.json中的值生成的图片的尺寸和大小，来判断图片的正确性
    func test_weather_icon_display() {
        let iconFromVM = vm.weatherIcon.pngData()! as NSData
        let iconFromJosn = UIImage(named: "snow")!.pngData()! as NSData
        
        XCTAssertEqual(vm.weatherIcon.size.width, 116.0)
        XCTAssertEqual(vm.weatherIcon.size.height, 108.0)
        XCTAssertEqual(iconFromVM, iconFromJosn)
    }

}
