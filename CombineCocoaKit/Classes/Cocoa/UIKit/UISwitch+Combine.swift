//
//  UISwitch+Combine.swift
//  CombineCocoa
//
//  Created by dongzb01 on 2022/7/28.
//

import UIKit
import Combine

@available(iOS 13.0, *)
public extension LCombineXWrapper where Base: UISwitch {
    @available(*, deprecated, message: "Typo. Use `isOn` instead", renamed: "isOn")
    var isOnPublisher: AnyPublisher<Bool, Never> {
        return isOn.eraseToAnyPublisher()
    }

    /// ‘ isOn ’属性的响应式包装器。支持双向绑定
    /// UISlider().lx.isOn <-> @Published var isOn: Bool
    var isOn: ControlPropertyBinder<Bool> {
        return self.controlProperty(
            events: .defaultValueEvents,
            getter: { uiSwitch in
                uiSwitch.isOn
            }, setter: { uiSwitch, value in
                uiSwitch.isOn = value
            })
    }
}
