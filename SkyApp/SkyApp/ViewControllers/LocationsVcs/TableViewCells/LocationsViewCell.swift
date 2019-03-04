//
//  LocationsViewCell.swift
//  SkyApp
//
//  Created by QDSG on 2019/3/4.
//  Copyright © 2019 SwifterTT. All rights reserved.
//

import UIKit

class LocationsViewCell: UITableViewCell {
    
    static let reuseIdentifier = "LocationsCell"
    
    @IBOutlet weak var label: UILabel!

    func configure(with vm: LocationRepresentable) {
        label.text = vm.labelText
    }

}
