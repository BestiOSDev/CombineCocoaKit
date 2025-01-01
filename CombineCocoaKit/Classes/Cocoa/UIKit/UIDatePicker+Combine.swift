//
//  UIDatePicker+Combine.swift
//  Pods
//
//  Created by dzb0409 on 2024/12/16.
//

#if canImport(Combine)

import UIKit
import Combine

@available(iOS 13.0, *)
public extension LCombineXWrapper where Base: UIDatePicker {
    /// date 属性的响应式包装器。支持双向绑定
    /// UIDatePicker().lx.date <-> @Published var date: Date
    var date: ControlPropertyBinder<Date> {
        return self.controlProperty(
            events: .defaultValueEvents,
            getter: { datePicker in
                datePicker.date
            }, setter: { datePicker, value in
                datePicker.date = value
            }
        )
    }

    /// `countDownDuration` 属性的响应式包装器。支持双向绑定
    /// UIDatePicker().lx.countDownDuration <-> @Published var time: TimeInterval
    var countDownDuration: ControlPropertyBinder<TimeInterval> {
        return self.controlProperty(
            events: .defaultValueEvents,
            getter: { datePicker in
                datePicker.countDownDuration
            }, setter: { datePicker, value in
                datePicker.countDownDuration = value
            }
        )
    }
}

#endif
