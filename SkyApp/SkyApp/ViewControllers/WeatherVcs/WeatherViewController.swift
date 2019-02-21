//
//  WeatherViewController.swift
//  SkyApp
//
//  Created by TT on 2019/2/20.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherContainerView: UIView!
    @IBOutlet weak var loadingFailedLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private func setupView() {
        weatherContainerView.isHidden = true
        loadingFailedLabel.isHidden = true
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

}
