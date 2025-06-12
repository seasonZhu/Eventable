//
//  EventBus.swift
//  Eventable_Example
//
//  Created by dy on 2025/6/12.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation

import Eventable


enum EventBus {
    enum User: String {
        case login
        case logout
    }
    
    enum Other: String {
        case hello
        case byebye
    }
}

extension EventBus.User: Eventable {}

extension EventBus.Other: Eventable {}
