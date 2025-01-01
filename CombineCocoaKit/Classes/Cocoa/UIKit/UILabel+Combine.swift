//
//  UILabel+Combine.swift
//  Pods
//
//  Created by dzb0409 on 2024/12/16.
//

import UIKit
import Combine

@available(iOS 13.0, *)
extension UILabel: LCombineXCompatible { }

@available(iOS 13.0, *)
extension LCombineXWrapper where Base: UILabel {
    
    /// 单向绑定 设置UILabel.text属性
    public var text: UIBinder<String?> {
        return UIBinder(target: self.base) {
            $0.text = $1
        }
    }
    
    /// 单向绑定 设置UILabel.attributedText属性
    public var attributedText: UIBinder<NSAttributedString?> {
        return UIBinder(target: self.base) {
            $0.attributedText = $1
        }
    }
    
    /// 单向绑定 设置UILabel.textColor属性
    public var textColor: UIBinder<UIColor> {
        return UIBinder(target: self.base) {
            $0.textColor = $1
        }
    }
    
}
