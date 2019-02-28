//
//  SettingsDateViewModelTests.swift
//  SkyAppTests
//
//  Created by QDSG on 2019/2/28.
//  Copyright © 2019 SwifterTT. All rights reserved.
//

import XCTest
@testable import SkyApp

class SettingsDateViewModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        
        // 恢复对它的改动。虽然事实上这个动作不会对我们造成任何影响，但我们应该养成在测试开始前后恢复环境的习惯
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.dateMode)
    }
    
    func test_date_display_in_text_mode() {
        let vm = SettingsDateViewModel(dateMode: .text)
        XCTAssertEqual(vm.labelText, "Fri, 01 December")
    }
    
    func test_date_display_in_digit_mode() {
        let vm = SettingsDateViewModel(dateMode: .digit)
        XCTAssertEqual(vm.labelText, "F, 12/01")
    }

    func test_date_mode_selected() {
        let dateMode: DateMode = .text
        
        UserDefaults.standard.set(dateMode.rawValue, forKey: UserDefaultsKey.dateMode)
        let vm = SettingsDateViewModel(dateMode: dateMode)
        XCTAssertEqual(vm.accessory, UITableViewCell.AccessoryType.checkmark)
    }
    
    func test_date_mode_unselected() {
        let dateMode: DateMode = .text
        
        UserDefaults.standard.set(dateMode.rawValue, forKey: UserDefaultsKey.dateMode)
        let vm = SettingsDateViewModel(dateMode: .digit)
        XCTAssertEqual(vm.accessory, .none)
    }
    
    func test_digit_mode_selected() {
        let dateMode: DateMode = .digit
        
        UserDefaults.standard.set(dateMode.rawValue, forKey: UserDefaultsKey.dateMode)
        let vm = SettingsDateViewModel(dateMode: dateMode)
        XCTAssertEqual(vm.accessory, .checkmark)
    }
    
    func test_digit_mode_unselected() {
        let dateMode: DateMode = .digit
        
        UserDefaults.standard.set(dateMode.rawValue, forKey: UserDefaultsKey.dateMode)
        let vm = SettingsDateViewModel(dateMode: .text)
        XCTAssertEqual(vm.accessory, .none)
    }
    
}
