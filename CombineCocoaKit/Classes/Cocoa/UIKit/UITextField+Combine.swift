//
//  UITextField+Combine.swift
//  CombineCocoaKit
//
//  Created by dongzb01 on 2022/7/28.
//

import UIKit
import Combine

@available(iOS 13.0, *)
extension LCombineXWrapper where Base: UITextField {
    
    @available(*, deprecated, message: "Typo. Use `value` instead", renamed: "value")
    public var textPublisher: ControlPropertyBinder<String> {
        value
    }
    
    /// ‘ value ’属性的响应式包装器。 支持双向绑定
    /// UITextField().lx.value <-> @Published var username: String
    public var value: ControlPropertyBinder<String> {
        self.controlProperty(events: .defaultValueEvents) { textField in
            textField.text ?? ""
        } setter: { textField, value in
            textField.text = value
        }
    }

    /// ‘ attributedText ’属性的响应式包装器。 支持双向绑定
    /// UITextField().lx.attributedTextPublisher <-> @Published var username: NSAttributedString?
    public var attributedTextPublisher: ControlPropertyBinder<NSAttributedString?> {
        self.controlProperty(events: .defaultValueEvents) { textField in
            textField.attributedText
        } setter: { textField, value in
            textField.attributedText = value
        }
    }
    
    @available(*, deprecated, message: "Typo. Use `didBeginEditing` instead", renamed: "didBeginEditing")
    public var didBeginEditingPublisher: AnyPublisher<UITextField, Never> {
        didBeginEditing
    }
    
    /// Reactive wrapper for `delegate` message.
    public var didBeginEditing: AnyPublisher<UITextField, Never> {
        let selector = #selector(UITextFieldDelegate.textFieldDidBeginEditing(_:))
        return self.proxy.intercept(selector).map { values in
            return values[0] as? UITextField ?? UITextField()
        }.eraseToAnyPublisher()
    }

    /// Reactive wrapper for `delegate` message.
    public var didEndEditing: AnyPublisher<UITextField, Never> {
        let selector = #selector(UITextFieldDelegate.textFieldDidEndEditing(_:))
        return self.proxy.intercept(selector).map { values in
            return values[0] as? UITextField ?? UITextField()
        }.eraseToAnyPublisher()
    }
    
    /// Reactive wrapper for `delegate` message.
    public var didChangeSelection: AnyPublisher<UITextField, Never> {
        let selector = #selector(UITextFieldDelegate.textFieldDidChangeSelection(_:))
        return self.proxy.intercept(selector).map { values in
            return values[0] as? UITextField ?? UITextField()
        }.eraseToAnyPublisher()
    }
    
    private var proxy: TextFieldDelegateProxy {
        return .proxy(for: base,
                      setter: #selector(setter: base.delegate),
                      getter: #selector(getter: base.delegate))
    }
    
}


private class TextFieldDelegateProxy: DelegateProxy<UITextFieldDelegate>, UITextFieldDelegate {
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        forwardee?.textFieldDidBeginEditing?(textField)
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        forwardee?.textFieldDidEndEditing?(textField)
    }
    
    @objc func textFieldDidChangeSelection(_ textField: UITextField) {
        forwardee?.textFieldDidChangeSelection?(textField)
    }
}

