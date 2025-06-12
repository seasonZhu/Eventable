# Eventable

[中文文档请点这里查看 → README_CN.md](README_CN.md)

[![CI Status](https://img.shields.io/travis/zhujilong1987@163.com/Eventable.svg?style=flat)](https://travis-ci.org/zhujilong1987@163.com/Eventable)
[![Version](https://img.shields.io/cocoapods/v/Eventable.svg?style=flat)](https://cocoapods.org/pods/Eventable)
[![License](https://img.shields.io/cocoapods/l/Eventable.svg?style=flat)](https://cocoapods.org/pods/Eventable)
[![Platform](https://img.shields.io/cocoapods/p/Eventable.svg?style=flat)](https://cocoapods.org/pods/Eventable)

## Current Status of Notification Usage

In iOS development, `NotificationCenter` is a common way for decoupled communication between modules. However, the traditional usage has the following pain points:

- Notification names are often strings, which are prone to typos and hard to maintain.
- Observers must be registered and removed manually, which is easy to forget and can lead to memory leaks or crashes.
- Code is scattered and lacks a unified event management approach.
- In reactive programming (RxSwift/Combine), the native Notification usage is not elegant enough.

## Why Eventable

**Eventable** uses protocols and extensions, combined with RxSwift and Combine, to provide a type-safe, reactive, and automatically released wrapper for Notification mechanisms, offering the following advantages:

- **Type Safety**: Use enums to manage notification names, avoiding hardcoding and typos.
- **Automatic Release**: RxSwift/Combine automatically manages the observer lifecycle, no need to remove manually.
- **Reactive Support**: Listen to notifications reactively with just one line of code, making code more concise.
- **Ease of Use**: Unified API for sending and listening to notifications, easy to maintain and extend.

## Installation

Eventable supports CocoaPods integration:

```ruby
pod 'Eventable'
```

Or add to your `Podfile`:

```ruby
pod 'Eventable', :git => 'https://github.com/seasonZhu/Eventable.git'
```

Then run in your project directory:

```sh
pod install
```

## Usage

### 1. Define Event Enums

```swift
enum EventBus: String {
    case userLogin
    case userLogout
}

extension EventBus: Eventable {}
```

Or for business separation:

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

### 2. Post Notifications

```swift
EventBus.userLogin.post()
EventBus.User.login.post(userInfo: ["name": "season"])
```

### 3. RxSwift Reactive Listening

```swift
EventBus.userLogin.rx
    .subscribe(onNext: { notification in
        // Handle event
    })
    .disposed(by: disposeBag)

// Or with object filtering
EventBus.User.login.rx(object: someObject)
    .subscribe { notification in
        // Handle event
    }
    .disposed(by: disposeBag)
```

### 4. Combine Reactive Listening

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

## Suitable Scenarios

- Decoupled communication between modules/pages
- Type-safe and easy-to-maintain event management
- RxSwift/Combine reactive development
- Medium and large Swift projects

## License

Eventable is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

---

For more details, please refer to the source code: [Eventable/Classes/Eventable.swift](Eventable/Classes/Eventable.swift)
