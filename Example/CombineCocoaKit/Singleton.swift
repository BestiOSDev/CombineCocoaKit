//
//  Singleton.swift
//  LCombineExtension_Example
//
//  Created by dongzb01 on 2022/10/31.
//

import Foundation
import CombineCocoaKit

class SingletonClass {
    var publisher: CombineCocoaKit.CurrentValueRelay<Int> = .init(value: 0)
    static let shared = SingletonClass()
    private init() {}
}
