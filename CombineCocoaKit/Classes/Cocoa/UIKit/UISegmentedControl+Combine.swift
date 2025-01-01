//
//  UISegmentedControl+Combine.swift
//  CombineCocoaKit
//
//  Created by dongzb01 on 2022/8/16.
//

import Combine
import UIKit

@available(iOS 13.0, *)
public extension LCombineXWrapper where Base: UISegmentedControl {
    /// 双向绑定 setter和getter selectedSegmentIndex
    /// (segmentedControl.lx.selectedSegmentIndex <-> $selectIndex).store(in: &cancellables)
    var selectedSegmentIndex: ControlPropertyBinder<Int> {
        return self.controlProperty(
            events: .defaultValueEvents,
            getter: { $0.selectedSegmentIndex },
            setter: { $0.selectedSegmentIndex = $1 }
        )
    }
    
    /// 单向绑定 设置 UISegmentedControl.title
    /// Just("red").bind(to: segmentedControl.lx.titleForSegment(at: 0)).store(in: &cancellables)
    func titleForSegment(at index: Int) -> UIBinder<String?> {
        return UIBinder(target: self.base) {
            $0.setTitle($1, forSegmentAt: index)
        }
    }
    
    /// 单向绑定 设置 UISegmentedControl.image
    /// Just(UIImage.init(systemName: "degreesign.celsius")).bind(to: segmentedControl.lx.imageForSegment(at: 2)).store(in: &cancellables)
    func imageForSegment(at index: Int) -> UIBinder<UIImage?> {
        return UIBinder(target: self.base) {
            $0.setImage($1, forSegmentAt: index)
        }
    }
}
