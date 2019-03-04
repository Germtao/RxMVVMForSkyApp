//
//  LocationViewModel.swift
//  SkyApp
//
//  Created by QDSG on 2019/3/4.
//  Copyright © 2019 SwifterTT. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationViewModel {
    let location: CLLocation?
    let locationText: String?
}

extension LocationViewModel: LocationRepresentable {
    var labelText: String {
        if let locationText = locationText {
            return locationText
        } else if let location = location {
            return location.toString
        }
        
        return "Unknow position"
    }
}
