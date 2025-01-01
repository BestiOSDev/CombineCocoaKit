//
//  UIButtonExt.swift
//  CombineCocoaKit
//
//  Created by dongzb01 on 2022/7/28.
//

import UIKit
import Combine

@available(iOS 13.0, *)
extension LAnyXWrapper where Base: UIButton {
    
    public var tapPublisher: AnyPublisher<Base, Never> {
        return self.controlEvent(.touchUpInside)
    }
    
    /// 单向绑定 给button设置title
    /// - Parameter state: state
    /// - Returns: UIBinder<String>
    /// Just("按钮1").bind(to: yellowButton.lx.title(for: .normal)).store(in: &cancellables)
    public func title(for state: UIControl.State) -> UIBinder<String> {
        UIBinder(target: self.base) {
            $0.setTitle($1, for: state)
        }
    }
    
    /// 单向绑定 给button设置titleColor
    /// - Parameter state: state
    /// - Returns: UIBinder<UIColor?>
    public func titleColor(for state: UIControl.State) -> UIBinder<UIColor?> {
        UIBinder(target: self.base) {
            $0.setTitleColor($1, for: state)
        }
    }
    
    /// 单向绑定给button设置image
    /// - Parameter controlState: state
    /// - Returns: UIBinder<UIImage?>
    public func image(for controlState: UIControl.State) -> UIBinder<UIImage?> {
        UIBinder(target: self.base) {
            $0.setImage($1, for: controlState)
        }
    }
    
    /// 单向绑定给button 设置backgroundImage
    /// - Parameter controlState: state
    /// - Returns: UIBinder<UIImage?>
    public func backgroundImage(for controlState: UIControl.State) -> UIBinder<UIImage?> {
        UIBinder(target: self.base) { button, image in
            button.setBackgroundImage(image, for: controlState)
        }
    }
    
}
