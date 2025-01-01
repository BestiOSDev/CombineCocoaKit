//
//  UIProgressView+Combine.swift
//  Pods
//
//  Created by dzb0409 on 2024/12/17.
//

import Combine
import UIKit

@available(iOS 13.0, *)
extension UIProgressView: LCombineXCompatible {}

@available(iOS 13.0, *)
public extension LCombineXWrapper where Base: UIProgressView {
    
    /// 单向绑定设置 UIProgressView.progress属性
    /// $prgress.bind(progressView.lx.progress)
    var progress: UIBinder<Float> {
        return UIBinder(target: self.base) { $0.progress = $1 }
    }
}



