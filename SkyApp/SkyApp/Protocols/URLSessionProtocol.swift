//
//  URLSessionProtocol.swift
//  SkyApp
//
//  Created by TT on 2019/2/19.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import Foundation

typealias DataTaskHandler = (Data?, URLResponse?, Error?) -> Void

/// 实现一个假的 URLSession 用于测试
protocol URLSessionProtocol {
    
    /// 定义了一个和URLSession.dataTask签名相同的方法
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol
}
