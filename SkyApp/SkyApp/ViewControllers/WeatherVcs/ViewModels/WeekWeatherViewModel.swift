//
//  WeekWeatherViewModel.swift
//  SkyApp
//
//  Created by TT on 2019/2/25.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import UIKit

struct WeekWeatherViewModel {
    let weatherDatas: [ForecastData]
    
    // Controller不应该直接与Model进行任何交互。
    // 因此，WeekWeatherViewModel还应该为Controller提供UITableViewDataSource需要的数据
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfDays: Int {
        return weatherDatas.count
    }
    
    /// 根据索引位置获取WeekWeatherDayViewModel的方法
    func viewModel(for index: Int) -> WeekWeatherDayViewModel {
        return WeekWeatherDayViewModel(weatherData: weatherDatas[index])
    }
}
