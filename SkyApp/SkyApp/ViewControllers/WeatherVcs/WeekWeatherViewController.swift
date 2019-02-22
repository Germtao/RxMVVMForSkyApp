//
//  WeekWeatherViewController.swift
//  SkyApp
//
//  Created by TT on 2019/2/22.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import UIKit

class WeekWeatherViewController: WeatherViewController {
    
    @IBOutlet weak var weekWeatherTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension WeekWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
