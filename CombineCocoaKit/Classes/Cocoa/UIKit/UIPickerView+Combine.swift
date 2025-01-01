//
//  UIPickerView+Combine.swift
//  Pods
//
//  Created by dzb0409 on 2024/12/17.
//

import UIKit
import Combine

@available(iOS 13.0, *)
extension UIPickerView: LCombineXCompatible { }

@available(iOS 13.0, *)
extension LCombineXWrapper where Base: UIPickerView {
    public var didSelect: AnyPublisher<(row: Int, component: Int), Never> {
        let selector = #selector(UIPickerViewDelegate.pickerView(_:didSelectRow:inComponent:))
        return self.proxy.intercept(selector).map { values in
            let row = values[1] as? Int ?? 0
            let component = values[2] as? Int ?? 0
            return (row, component)
        }.eraseToAnyPublisher()
    }

    private var proxy: PickerViewDelegateProxy {
        return .proxy(for: base,
                      setter: #selector(setter: base.delegate),
                      getter: #selector(getter: base.delegate))
    }
    
    /// 单向绑定 选中pickerView 某一行
    public func selectedRow(inComponent component: Int) -> UIBinder<Int> {
        return UIBinder(target: self.base) { $0.selectRow($1, inComponent: component, animated: false) }
    }
    
    /// 单向绑定 刷新pickerView所有区
    public var reloadAllComponents: UIBinder<Void> {
        return UIBinder(target: self.base) { base, _ in base.reloadAllComponents() }
    }
    
    /// 单向绑定 刷新pickerView 某个区
    public var reloadComponent: UIBinder<Int> {
        return UIBinder(target: self.base) { $0.reloadComponent($1) }
    }
}

private class PickerViewDelegateProxy: DelegateProxy<UIPickerViewDelegate>, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        forwardee?.pickerView?(pickerView, didSelectRow: row, inComponent: component)
    }
}
