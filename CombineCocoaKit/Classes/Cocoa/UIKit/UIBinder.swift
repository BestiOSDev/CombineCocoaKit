//
//  UIBinder.swift
//  Pods
//
//  Created by dzb0409 on 2024/12/16.
//
import Combine

@available(iOS 13.0, *)
public struct UIBinder<Value>: Binder {
    
    private let binder: AnyBinder<Value>
    
    public func onNext(_ value: Value) {
        self.binder.onNext(value)
    }
    
    public init<Target: AnyObject>(target: Target, action: @escaping (Target, Value) -> Void) {
        self.binder = .init(target: target, action: action)
    }
}
