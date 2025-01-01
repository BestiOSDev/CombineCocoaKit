//
//  UISlider+Combine.swift
//  CombineCocoa
//
//  Created by dongzb01 on 2022/7/28.
//

import UIKit
import Combine

@available(iOS 13.0, *)
public extension LCombineXWrapper where Base: UISlider {
    @available(*, deprecated, message: "Typo. Use `value` instead", renamed: "value")
    var valuePublisher: AnyPublisher<Float, Never> {
        return value.eraseToAnyPublisher()
    }
    /// ‘ value ’属性的响应式包装器。支持双向绑定
    /// UISlider().lx.value <-> @Published var progress: Float
    var value: ControlPropertyBinder<Float> {
        return self.controlProperty(events: .defaultValueEvents) { slider in
            slider.value
        } setter: { slider, value in
            slider.value = value
        }
    }
}
