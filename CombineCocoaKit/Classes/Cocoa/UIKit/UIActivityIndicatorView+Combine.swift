//
//  UIActivityIndicatorView+Combine.swift
//  Pods
//
//  Created by dzb0409 on 2024/12/18.
//
import Combine

@available(iOS 13.0, *)
extension UIActivityIndicatorView: LCombineXCompatible { }

@available(iOS 13.0, *)
extension LCombineXWrapper where Base: UIActivityIndicatorView {
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods. 支持单向绑定
    ///  $isLoading.bind(to: activityView.lx.isAnimating).store(in: &cancellables)
    public var isAnimating: UIBinder<Bool> {
        UIBinder(target: self.base) { activityIndicator, active in
            if active {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
}
