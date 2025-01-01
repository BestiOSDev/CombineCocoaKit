////
////  NSTextStorage+Combine.swift
////  CombineCocoa
////
////  Created by Shai Mishali on 10/08/2020.
////  Copyright © 2020 Combine Community. All rights reserved.
////

#if canImport(Combine)
import UIKit

@available(iOS 13.0, *)
extension NSTextStorage {
  /// Combine publisher for `NSTextStorageDelegate.textStorage(_:didProcessEditing:range:changeInLength:)`
  var didProcessEditingRangeChangeInLengthPublisher: AnyPublisher<(editedMask: NSTextStorage.EditActions, editedRange: NSRange, delta: Int), Never> {
    let selector = #selector(NSTextStorageDelegate.textStorage(_:didProcessEditing:range:changeInLength:))

    return delegateProxy
          .intercept(selector)
      .map { args -> (editedMask: NSTextStorage.EditActions, editedRange: NSRange, delta: Int) in
          // swiftlint:disable force_cast
          let editedMask = NSTextStorage.EditActions(rawValue: args[1] as! UInt)
          let editedRange = (args[2] as! NSValue).rangeValue
          let delta = args[3] as! Int
          return (editedMask, editedRange, delta)
          // swiftlint:enable force_cast
      }
      .eraseToAnyPublisher()
  }

  private var delegateProxy: NSTextStorageDelegateProxy {
      return .proxy(for: self, setter: #selector(setter: self.delegate), getter: #selector(getter: self.delegate))
  }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private class NSTextStorageDelegateProxy: DelegateProxy<NSTextStorageDelegate>, NSTextStorageDelegate {
    @objc func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        forwardee?.textStorage?(textStorage, didProcessEditing: editedMask, range: editedRange, changeInLength: delta)
    }
}
#endif
