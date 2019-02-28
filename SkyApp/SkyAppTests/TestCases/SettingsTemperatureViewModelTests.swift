//
//  SettingsTemperatureViewModelTests.swift
//  SkyAppTests
//
//  Created by QDSG on 2019/2/28.
//  Copyright © 2019 SwifterTT. All rights reserved.
//

import XCTest
@testable import SkyApp

class SettingsTemperatureViewModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_temperature_display_in_celsius() {
        let mode: TemperatureMode = .celsius
        
        UserDefaults.standard.set(mode.rawValue, forKey: UserDefaultsKey.temperatureMode)
        let vm = SettingsTemperatureViewModel(temperatureMode: mode)
        XCTAssertEqual(vm.labelText, "Celsius")
    }
    
    func test_temperature_display_in_fahrenheit() {
        let mode: TemperatureMode = .fahrenheit
        
        UserDefaults.standard.set(mode.rawValue, forKey: UserDefaultsKey.temperatureMode)
        let vm = SettingsTemperatureViewModel(temperatureMode: mode)
        XCTAssertEqual(vm.labelText, "Fahrenhait")
    }
    
    func test_celsius_mode_selected() {
        let mode = TemperatureMode.celsius
        
        UserDefaults.standard.set(mode.rawValue, forKey: UserDefaultsKey.temperatureMode)
        let vm = SettingsTemperatureViewModel(temperatureMode: mode)
        XCTAssertEqual(vm.accessory, .checkmark)
    }
    
    func test_celsius_mode_unselected() {
        let mode = TemperatureMode.celsius
        
        UserDefaults.standard.set(mode.rawValue, forKey: UserDefaultsKey.temperatureMode)
        let vm = SettingsTemperatureViewModel(temperatureMode: .fahrenheit)
        XCTAssertEqual(vm.accessory, .none)
    }
    
    func test_fahrenheit_mode_selected() {
        let mode = TemperatureMode.fahrenheit
        
        UserDefaults.standard.set(mode.rawValue, forKey: UserDefaultsKey.temperatureMode)
        let vm = SettingsTemperatureViewModel(temperatureMode: mode)
        XCTAssertEqual(vm.accessory, .checkmark)
    }
    
    func test_fahrenheit_mode_unselected() {
        let mode = TemperatureMode.fahrenheit
        
        UserDefaults.standard.set(mode.rawValue, forKey: UserDefaultsKey.temperatureMode)
        let vm = SettingsTemperatureViewModel(temperatureMode: .celsius)
        XCTAssertEqual(vm.accessory, .none)
    }

}
