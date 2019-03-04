//
//  AddLocationViewModel.swift
//  SkyApp
//
//  Created by QDSG on 2019/3/4.
//  Copyright © 2019 SwifterTT. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - 由于要在viewModel中更新当前的操作状态, 定义为 class
class AddLocationViewModel {
    /// 用户输入的内容
    var queryText: String = "" {
        didSet {
            geocode(address: queryText)
        }
    }
    
    /// 用于查询用户输入的CLGeocoder
    private lazy var geocoder = CLGeocoder()
    
    /// 记录当前查询状态
    private var isQuerying = false {
        didSet {
            queryingStatusDidChange?(isQuerying)
        }
    }
    
    var queryingStatusDidChange: ((Bool) -> Void)?
    var locationsDidChange: (([Location]) -> Void)?
    
    /// 位置数组
    private var locations = [Location]() {
        didSet {
            locationsDidChange?(locations)
        }
    }
    
    /// 查询到位置信息的数量
    var numberOfLocations: Int {
        return locations.count
    }
    
    /// 是否查询到了信息
    var hasLocationsResult: Bool {
        return numberOfLocations > 0
    }
    
    /// 返回vm
    func locationViewModel(at index: Int) -> LocationRepresentable? {
        guard let location = location(at: index) else { return nil }
        return LocationViewModel(location: location.location, locationText: location.name)
    }
    
    /// 返回具体地址信息
    func location(at index: Int) -> Location? {
        guard index < numberOfLocations else {
            return nil
        }
        return locations[index]
    }
    
    // MARK: - Helpers
    private func geocode(address: String?) {
        guard let address = address, !address.isEmpty else {
            locations.removeAll()
            return
        }
        
        isQuerying = true
        
        geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            DispatchQueue.main.async {
                self?.processResponse(with: placemarks, error: error)
            }
        }
    }
    
    /// 处理解析结果
    private func processResponse(with placemarks: [CLPlacemark]?, error: Error?) {
        isQuerying = false
        var locs = [Location]()
        
        if let error = error {
            print("Cannot handle Geocode Address! \(error)")
        } else if let results = placemarks {
            locs = results.compactMap {
                guard let name = $0.name else { return nil }
                guard let location = $0.location else { return nil }
                
                return Location(name: name,
                                latitude: location.coordinate.latitude,
                                longitude: location.coordinate.longitude)
            }
            
            locations = locs
        }
    }
}
