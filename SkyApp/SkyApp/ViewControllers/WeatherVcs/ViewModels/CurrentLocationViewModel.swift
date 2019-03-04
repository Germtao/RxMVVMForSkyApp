//
//  CurrentLocationViewModel.swift
//  SkyApp
//
//  Created by QDSG on 2019/3/4.
//  Copyright © 2019 SwifterTT. All rights reserved.
//

import Foundation

struct CurrentLocationViewModel {
    var location: Location
    
    var city: String {
        return location.name
    }
    
    static let empty = CurrentLocationViewModel(location: Location.empty)
    
    var isEmpty: Bool {
        return self.location == Location.empty
    }
}
