//
//  CLLocationManager+Rx.swift
//  SkyApp
//
//  Created by QDSG on 2019/3/8.
//  Copyright © 2019 SwifterTT. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import CoreLocation

/**  搞清楚RxCocoa处理UIKit delegate的机制略显复杂, 简单来说:
 
     设置了一个delegate proxy, 这个proxy可以替我们从原生delegate获取数据, 然后变成 Observables 供我们使用.
     然后要做的就是自己为 CLLocationManager 定义一个这样的 proxy, 注册到RxCocoa
 
     HasDelegate - RxCocoa定义的一个protocol, 两个约束:
         1. Delegate - 表示原生delegate的类型, 此处为 CLLocationManagerDelegate
         2. delegate - 表示用于 “代理请求” 的对象, 此处为 CLLocationManagerDelegateProxy
 */
extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}

/**  需要实现CLLocationManagerDelegate的proxy, 声明:
 
     1. DelegateProxyType - RxCocoa定义的protocol, 它约束了RxCocoa中, delegate proxy的接口
     2. DelegateProxy<CLLocationManager, CLLocationManagerDelegate> - 可以理解为是遵从DelegateProxyType的一份标准实现,
        这份实现需要两个泛型参数, 分别是类型自身和与这个类型搭配工作的原生Delegate的类型
     3. 最后, 作为CLLocationManager的delegate proxy, 当然得让它也遵从CLLocationManagerDelegate
 */
class CLLocationManagerDelegateProxy:
DelegateProxy<CLLocationManager, CLLocationManagerDelegate>,
DelegateProxyType,
CLLocationManagerDelegate {
    weak private(set) var locationManager: CLLocationManager?
    
    init(locationManager: ParentObject) {
        self.locationManager = locationManager
        super.init(parentObject: locationManager, delegateProxy: CLLocationManagerDelegateProxy.self)
    }
    
    /// 用于向 RxCocoa 注册我们自定义的DelegateProxyType
    static func registerKnownImplementations() {
        self.register {
            CLLocationManagerDelegateProxy(locationManager: $0)
        }
    }
}

extension Reactive where Base: CLLocationManager {
    /**
     唯一注意的是🐷: 绝对不要手工调用init方法创建Proxy delegate对象, 而始终要通过proxy方法返回
     */
    var delegate: CLLocationManagerDelegateProxy {
        return CLLocationManagerDelegateProxy.proxy(for: base)
    }
    
    var didUpdateLocations: Observable<[CLLocation]> {
        let sel = #selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:))
        
        return delegate.methodInvoked(sel).map { parameters in  // methodInvoked -> Observable<[Any]>
            parameters[1] as! [CLLocation]
        }
    }
}
