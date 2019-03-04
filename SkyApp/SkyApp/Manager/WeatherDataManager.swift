//
//  WeatherDataManager.swift
//  SkyApp
//
//  Created by TT on 2019/2/19.
//  Copyright © 2019年 SwifterTT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Mock出来一套返回数据的API
internal class DarkSkyURLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol {
        return DarkSkyURLSessionDataTask(request: request, completion: completionHandler)
    }
}

internal class DarkSkyURLSessionDataTask: URLSessionDataTaskProtocol {
    private let request: URLRequest
    private let completion: DataTaskHandler
    
    init(request: URLRequest, completion: @escaping DataTaskHandler) {
        self.request = request
        self.completion = completion
    }
    
    func resume() {
        // 1. ProcessInfo.processInfo.environment
        //    加载了测试时使用的JSON，这就是访问进程环境变量的方法
        if let json = ProcessInfo.processInfo.environment["FakeJSON"] {
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)
            let data = json.data(using: .utf8)!
            
            // 2. 直接调用了completion方法，这样就在测试过程中把异步回调函数，变成了同步的
            completion(data, response, nil)
        }
    }
}

// MARK: - 在生产和测试环境之间进行切换
internal struct Config {
    private static func isUITesting() -> Bool {
        return ProcessInfo.processInfo.arguments.contains("UI-TESTING")
    }
    
    static var urlSession: URLSessionProtocol = {
        if isUITesting() {
            return DarkSkyURLSession()
        } else {
            return URLSession.shared
        }
    }()
}

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
    
    static let shared = WeatherDataManager(
        baseURL: API.authenticatedURL,
        urlSession: Config.urlSession) // 支持环境切换
    
    /// 回调
    typealias CompletionHandler = (WeatherData?, WeatherDataError?) -> Void
    
    /// 请求天气数据, 变成一个 Observable
    func weatherDataAt(latitude: Double, longitude: Double) -> Observable<WeatherData> {
        // 1. Concatenate the URL
        let url = baseURL.appendingPathComponent("\(latitude), \(longitude)")
        var request = URLRequest(url: url)
        
        // 2. Set HTTP header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        // 3. Launch the request
        return (self.urlSession as! URLSession).rx.data(request: request).map {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            return try decoder.decode(WeatherData.self, from: $0)
        }
    }
}
