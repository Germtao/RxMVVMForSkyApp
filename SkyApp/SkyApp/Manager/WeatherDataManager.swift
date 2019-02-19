//
//  WeatherDataManager.swift
//  SkyApp
//
//  Created by TT on 2019/2/19.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import Foundation

enum WeatherDataError: Error {
    case failedRequest     // 非法请求
    case invalidResponse   // 非法返回
    case unkown            // 未知错误
}

/// 由于该类不会作为其它类的基类
/// 所以用关键字final修饰 - 可以提高这个对象的访问性能
final class WeatherDataManager {
    internal let baseURL: URL
    internal let urlSession: URLSessionProtocol  // internal - 方便在测试用例中访问这些元素
    
    internal init(baseURL: URL, urlSession: URLSessionProtocol) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
    static let shared = WeatherDataManager(baseURL: API.authenticatedURL, urlSession: URLSession.shared)
    
    /// 回调
    typealias CompletionHandler = (WeatherData?, WeatherDataError?) -> Void
    
    /// 请求天气数据
    func weatherDataAt(latitude: Double, longitude: Double, completion: @escaping CompletionHandler) {
        // 1. Concatenate the URL
        let url = baseURL.appendingPathComponent("\(latitude), \(longitude)")
        var request = URLRequest(url: url)
        
        // 2. Set HTTP header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        // 3. Launch the request
        // Dependency Injection - 依赖注入
        self.urlSession.dataTask(with: request) { (data, response, error) in
            // 4. Get the response here
            DispatchQueue.main.async {
                self.didFinishGettingWeatherData(data: data, respose: response, error: error, completion: completion)
            }
        }.resume()
    }
}

// MARK: - Helper
extension WeatherDataManager {
    func didFinishGettingWeatherData(data: Data?, respose: URLResponse?, error: Error?, completion: CompletionHandler) {
        if let _ = error {
            completion(nil, .failedRequest)
        } else if let data = data, let respose = respose as? HTTPURLResponse {
            if respose.statusCode == 200 {
                do {
                    let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                    completion(weatherData, nil)
                } catch {
                    completion(nil, WeatherDataError.invalidResponse)
                }
            } else {
                completion(nil, WeatherDataError.failedRequest)
            }
        } else {
            completion(nil, WeatherDataError.unkown)
        }
    }
}
