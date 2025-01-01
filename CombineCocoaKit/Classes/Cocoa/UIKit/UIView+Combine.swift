//
//  UIView+Combine.swift
//  Pods
//
//  Created by dzb0409 on 2024/12/25.
//

#if canImport(Combine)

import Combine

@available(iOS 13.0, *)
extension LCombineXWrapper where Base: UIView {
    /// UIView属性和Publisher类型双向绑定
    public func twoBind<Output>(keyPath: ReferenceWritableKeyPath<Base, Output>, to published: any Publisher<Output, Never>) -> AnyCancellable {
        published.assign(to: keyPath, on: self.base)
    }
}

#endif
