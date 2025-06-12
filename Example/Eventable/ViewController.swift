//
//  ViewController.swift
//  Eventable
//
//  Created by seasonZhu on 06/12/2025.
//  Copyright (c) 2025 seasonZhu. All rights reserved.
//

import UIKit
import Combine

import RxSwift

import Eventable

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        useWithRxSwift()
        useWithCombine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func useWithRxSwift() {
        EventBus.User.login.rx().subscribe { notification in
            print("rx() login")
            guard let userInfo = notification.userInfo as? [String: String] else {
                return
            }
            
            let name = userInfo["name"]
            print(name ?? "empty")
            
        }.disposed(by: disposeBag)
        
        EventBus.User.login.rx.subscribe { _ in
            print("rx login")
        }.disposed(by: disposeBag)
        
        EventBus.User.login.post(userInfo: ["name": "seasonZhu"])
        
        EventBus.User.login.rx().subscribe { notification in
            print("rx() login")
            guard let userInfo = notification.userInfo as? [String: String] else {
                return
            }
            
            let name = userInfo["name"]
            print(name ?? "empty")
            
        }.disposed(by: disposeBag)
    }
    
    private func useWithCombine() {
        EventBus.User.logout.publisher()
            .sink { notification in
                print("publisher() logout")
                
                guard let userInfo = notification.userInfo as? [String: String] else {
                    return
                }
                
                let name = userInfo["name"]
                print(name ?? "empty")
            }
            .store(in: &cancellables)
        
        EventBus.User.logout.publisher
            .sink { notification in
                print("publisher logout")
            }
            .store(in: &cancellables)
        
        EventBus.User.logout.post(userInfo: ["name": "zhu"])
    }
}
