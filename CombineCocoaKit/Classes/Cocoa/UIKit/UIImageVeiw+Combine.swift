//
//  UIImageVeiw+Combine.swift
//  Pods
//
//  Created by dzb0409 on 2024/12/17.
//

import UIKit
import Combine

@available(iOS 13.0, *)
extension UIImageView: LCombineXCompatible {}

@available(iOS 13.0, *)
public extension LCombineXWrapper where Base: UIImageView {
    /// 单向绑定 设置 UIImageView.image属性
    var image: UIBinder<UIImage?> {
        return UIBinder(target: self.base) { $0.image = $1 }
    }

    /// 单向绑定 设置 UIImageView.highlightedImage属性
    var highlightedImage: UIBinder<UIImage?> {
        return UIBinder(target: self.base) { $0.highlightedImage = $1 }
    }
}
