# Eventable

[![CI Status](https://img.shields.io/travis/zhujilong1987@163.com/Eventable.svg?style=flat)](https://travis-ci.org/zhujilong1987@163.com/Eventable)
[![Version](https://img.shields.io/cocoapods/v/Eventable.svg?style=flat)](https://cocoapods.org/pods/Eventable)
[![License](https://img.shields.io/cocoapods/l/Eventable.svg?style=flat)](https://cocoapods.org/pods/Eventable)
[![Platform](https://img.shields.io/cocoapods/p/Eventable.svg?style=flat)](https://cocoapods.org/pods/Eventable)

## 当前 Notification 使用现状

在 iOS 开发中，`NotificationCenter` 是模块间解耦通信的常用方式。但传统写法存在如下痛点：

- 通知名多为字符串，易拼写错误，难以维护。
- 观察者的注册与移除需手动管理，容易遗忘导致内存泄漏或崩溃。
- 代码分散，缺乏统一的事件管理方式。
- 响应式编程（RxSwift/Combine）下，原生 Notification 用法不够优雅。

## 为什么需要 Eventable

**Eventable** 通过协议和扩展的方式，结合 RxSwift 和 Combine，对 Notification 机制进行了类型安全、响应式、自动释放的封装，带来如下优势：

- **类型安全**：用枚举统一管理通知名，避免硬编码和拼写错误。
- **自动释放**：RxSwift/Combine 自动管理观察者生命周期，无需手动移除。
- **响应式支持**：一行代码即可响应式监听通知，代码更简洁。
- **易用性**：统一的 API，发送和监听通知方式一致，便于维护和扩展。

## 集成说明

Eventable 支持 CocoaPods 集成：

```ruby
pod 'Eventable'
```

或在你的 `Podfile` 中添加：

```ruby
pod 'Eventable', :git => 'https://github.com/seasonZhuZhu/Eventable.git'
```

然后在项目目录下执行：

```sh
pod install
```

## 使用说明

### 1. 定义事件枚举

```swift
enum EventBus: String {
    case userLogin
    case userLogout
}

extension EventBus: Eventable {}
```

或分业务隔离：

```swift
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
```

### 2. 发送通知

```swift
EventBus.userLogin.post()
EventBus.User.login.post(userInfo: ["name": "season"])
```

### 3. RxSwift 响应式监听

```swift
EventBus.userLogin.rx
    .subscribe(onNext: { notification in
        // 处理事件
    })
    .disposed(by: disposeBag)

// 或带 object 过滤
EventBus.User.login.rx(object: someObject)
    .subscribe { notification in
        // 处理事件
    }
    .disposed(by: disposeBag)
```

### 4. Combine 响应式监听

```swift
import Combine

var cancellables = Set<AnyCancellable>()

EventBus.User.logout.publisher()
    .sink { notification in
        print("publisher() logout")
        guard let userInfo = notification.userInfo as? [String: String] else { return }
        print(userInfo["name"] ?? "empty")
    }
    .store(in: &cancellables)

EventBus.User.logout.publisher
    .sink { notification in
        print("publisher logout")
    }
    .store(in: &cancellables)
```

## 适用场景

- 模块/页面间解耦通信
- 需要类型安全、易维护的事件管理
- RxSwift/Combine 响应式开发
- 中大型 Swift 项目

## License

Eventable is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

---

更多细节请参考源码：[Eventable/Classes/Eventable.swift](Eventable/Classes/Eventable.swift)