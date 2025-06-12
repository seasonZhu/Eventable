//
//  Eventable.swift
//
//  Created by seasonZhu on 2025/6/10.
//  Copyright © 2025 seasonZhu. All rights reserved.
//

import Foundation
import Combine

import RxSwift
import RxCocoa

public protocol Eventable: RawRepresentable where RawValue == String {
    
    func post(object: AnyObject?, userInfo: [AnyHashable: Any]?)

    func rx(object: AnyObject?) -> Observable<Notification>
    
    var rx: Observable<Notification> { get }
    
    var publisher: AnyPublisher<Notification, Never> { get }
    
    func publisher(object: AnyObject?) -> AnyPublisher<Notification, Never>
    
}

public extension Eventable {
    func post(object: AnyObject? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: rawValue), object: object, userInfo: userInfo)
    }
}

public extension Eventable {
    func rx(object: AnyObject? = nil) -> Observable<Notification> {
        return NotificationCenter.default.rx.notification(Notification.Name(rawValue: rawValue), object: object)
    }
    
    var rx: Observable<Notification> {
        return NotificationCenter.default.rx.notification(Notification.Name(rawValue: rawValue))
    }
}

public extension Eventable {
    var publisher: AnyPublisher<Notification, Never> {
        NotificationCenter.default
            .publisher(for: Notification.Name(rawValue: rawValue))
            .eraseToAnyPublisher()
    }
    
    func publisher(object: AnyObject? = nil) -> AnyPublisher<Notification, Never> {
        NotificationCenter.default
            .publisher(for: Notification.Name(rawValue: rawValue), object: object)
            .eraseToAnyPublisher()
    }
}
