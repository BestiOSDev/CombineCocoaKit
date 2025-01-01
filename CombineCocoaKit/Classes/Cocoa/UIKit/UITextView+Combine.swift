//
//  UITextView+Combine.swift
//  CombineCocoa
//
//  Created by dongzb01 on 2022/7/28.
//

import UIKit
import Combine

@available(iOS 13.0, *)
extension LCombineXWrapper where Base: UITextView {
    
    @available(*, deprecated, message: "Typo. Use `value` instead", renamed: "value")
    public var textPublisher: AnyPublisher<String, Never> {
        return value
    }
    
    /// A Combine publisher for the `UITextView's` value.
    ///
    /// - note: This uses the underlying `NSTextStorage` to make sure
    ///         autocorrect changes are reflected as well.
    ///
    /// - seealso: https://git.io/JJM5Q
    public var value: AnyPublisher<String, Never> {
        Deferred { [weak textView = self.base] in
            textView?.textStorage
                .didProcessEditingRangeChangeInLengthPublisher
                .map { _ in textView?.text ?? "" }
                .prepend(textView?.text ?? "")
                .eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    /// Reactive wrapper for `delegate` message.
    public var didBeginEditing: AnyPublisher<UITextView, Never> {
        let selector = #selector(UITextViewDelegate.textViewDidBeginEditing(_:))
        return self.proxy.intercept(selector).map { values in
            return values[0] as? UITextView ?? UITextView()
        }.eraseToAnyPublisher()
    }

    /// Reactive wrapper for `delegate` message.
    public var didEndEditing: AnyPublisher<UITextView, Never> {
        let selector = #selector(UITextViewDelegate.textViewDidEndEditing(_:))
        return self.proxy.intercept(selector).map { values in
            return values[0] as? UITextView ?? UITextView()
        }.eraseToAnyPublisher()
    }

    /// Reactive wrapper for `delegate` message.
    public var didChange: AnyPublisher<UITextView, Never> {
        let selector = #selector(UITextViewDelegate.textViewDidChange(_:))
        return self.proxy.intercept(selector).map { values in
            return values[0] as? UITextView ?? UITextView()
        }.eraseToAnyPublisher()
    }

    /// Reactive wrapper for `delegate` message.
    public var didChangeSelection: AnyPublisher<UITextView, Never> {
        let selector = #selector(UITextViewDelegate.textViewDidChangeSelection(_:))
        return self.proxy.intercept(selector).map { values in
            return values[0] as? UITextView ?? UITextView()
        }.eraseToAnyPublisher()
    }
    
    private var proxy: TextViewDelegateProxy {
        return .proxy(for: base,
                      setter: #selector(setter: base.delegate),
                      getter: #selector(getter: base.delegate))
    }
}

private class TextViewDelegateProxy: DelegateProxy<UITextViewDelegate>, UITextViewDelegate {
    
    @objc func textViewDidBeginEditing(_ textView: UITextView) {
        forwardee?.textViewDidBeginEditing?(textView)
    }
    
    @objc func textViewDidEndEditing(_ textView: UITextView) {
        forwardee?.textViewDidEndEditing?(textView)
    }
    
    @objc func textViewDidChange(_ textView: UITextView) {
        forwardee?.textViewDidChange?(textView)
    }
    
    @objc func textViewDidChangeSelection(_ textView: UITextView) {
        forwardee?.textViewDidChangeSelection?(textView)
    }
}
