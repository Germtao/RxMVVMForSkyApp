//
//  SettingsTableViewController.swift
//  SkyApp
//
//  Created by TT on 2019/2/25.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import UIKit

protocol SettingsTableViewControllerDelegate: class {
    func controllerDidChangeTimeMode(controller: SettingsTableViewController)
    func controllerDidChangeTemperatureMode(controller: SettingsTableViewController)
}

/// 1. 显示日期和温度的配置
/// 2. 响应配置变更之后的动作
class SettingsTableViewController: UITableViewController {
    
    weak var delegate: SettingsTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

}

// MARK: - UITableViewDataSource
extension SettingsTableViewController {
    
    // 添加一个内嵌enum，定义一些基本信息。这样，有助于我们提高代码的可读性
    private enum Section: Int {
        case date
        case temperature
        
        var numberOfRows: Int {
            return 2
        }
        
        static var count: Int {
            return Section.temperature.rawValue + 1
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { fatalError("Unexpected section index") }
        return section.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.reuseIdentifier,
            for: indexPath) as? SettingsTableViewCell else {
                fatalError("Unexpected talbe view cell")
        }
        
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected section index")
        }
        
        // ViewModel不一定得是一个View Controller持有的属性，也可以只一个方法的局部变量而已
        switch section {
        case .date:
            guard let dateMode = DateMode(rawValue: indexPath.row) else {
                fatalError("Invalide IndexPath")
            }
            let vm = SettingsDateViewModel(dateMode: dateMode)
            cell.accessoryType = vm.accessory
            cell.label.text = vm.labelText
            
        case .temperature:
            guard let temperatureMode = TemperatureMode(rawValue: indexPath.row) else {
                fatalError("Invalide IndexPath")
            }
            let vm = SettingsTemperatureViewModel(temperatureMode: temperatureMode)
            cell.accessoryType = vm.accessory
            cell.label.text = vm.labelText
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "日期格式"
        }
        return "温度单位"
    }
}

// MARK: - UITableViewDelegate
extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected section index")
        }
        switch section {
        case .date:
            let dateMode = UserDefaults.dateMode()
            guard indexPath.row != dateMode.rawValue else { return }
            if let newMode = DateMode(rawValue: indexPath.row) {
                UserDefaults.setDateMode(to: newMode)
            }
            
            delegate?.controllerDidChangeTimeMode(controller: self)
            
        case .temperature:
            let temperatureMode = UserDefaults.temperatureMode()
            guard indexPath.row != temperatureMode.rawValue else { return }
            if let newMode = TemperatureMode(rawValue: indexPath.row) {
                UserDefaults.setTemperatureMode(to: newMode)
            }
            
            delegate?.controllerDidChangeTemperatureMode(controller: self)
        }
        
        let sections = IndexSet(integer: indexPath.section)
        tableView.reloadSections(sections, with: .none)
    }
}
