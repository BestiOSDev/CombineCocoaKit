//
//  UIControl+ControlEventPublisher.swift
//  AFNetworking
//
//  Created by dongzb01 on 2022/7/27.
//
import UIKit
import Combine

@available(iOS 13.0, *)
extension UIControl: LCombineXCompatible { }

@available(iOS 13.0, *)
public extension LCombineXWrapper where Base: UIControl {
    /// 给 UIControl 及其子类添加点击事件
    /// - Parameter events: 事件类型
    /// - Returns: 返回事件发布者对象
    func controlEvent(_ events: UIControl.Event) -> AnyPublisher<Base, Never> {
        // 对 publisher 类型擦除不想暴露给外界 ControlEventPublisher 类型Publisher
        return ControlEventPublisher.init(control: self.base, events: events).eraseToAnyPublisher()
    }
    /// 单向绑定 给button设置isEnabled
    /// - Parameter state: state
    var isEnabled: UIBinder<Bool> {
        return UIBinder(target: self.base) {
            $0.isEnabled = $1
        }
    }
    
    /// 单向绑定 给button设置isSelected
    var isSelected: UIBinder<Bool> {
        return UIBinder(target: self.base) {
            $0.isSelected = $1
        }
    }
    /// 单向绑定 给button设置isHighlighted
    var isHighlighted: UIBinder<Bool> {
        return UIBinder(target: self.base) {
            $0.isHighlighted = $1
        }
    }
    
    /// 单向绑定 给button设置backgroundColor
    var backgroundColor: UIBinder<UIColor?> {
        UIBinder(target: self.base) {
            $0.backgroundColor = $1
        }
    }
    
}
