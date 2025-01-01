//
//  UIScrollView+Combine.swift
//  CombineCocoa
//
//  Created by dongzb01 on 2022/7/28.
//

import UIKit
import Combine

@available(iOS 13.0, *)
extension UIScrollView: LCombineXCompatible { }

// swiftlint:disable force_cast
@available(iOS 13.0, *)
public extension LCombineXWrapper where Base: UIScrollView {
    
    /// 单向绑定isScrollEnabled属性
    var isScrollEnabled: UIBinder<Bool> {
        return UIBinder(target: self.base) { scrollView, enabled in
            scrollView.isScrollEnabled = enabled
        }
    }
    
    /// A publisher emitting content offset changes from this UIScrollView.
    var contentOffset: AnyPublisher<CGPoint, Never> {
        self.base.publisher(for: \.contentOffset)
            .eraseToAnyPublisher()
    }
    
    /// Combine wrapper for `scrollViewDidScroll(_:)`
    var didScrollPublisher: AnyPublisher<Void, Never> {
        let selector = #selector(UIScrollViewDelegate.scrollViewDidScroll(_:))
        return self.proxy.intercept(selector).eraseToAnyPublisher()
    }
   
    /// Combine wrapper for `scrollViewWillBeginDecelerating(_:)`
    var willBeginDeceleratingPublisher: AnyPublisher<Void, Never> {
        let selector = #selector(UIScrollViewDelegate.scrollViewWillBeginDecelerating(_:))
        return self.proxy.intercept(selector)
            .eraseToAnyPublisher()
    }
    
    /// Combine wrapper for `scrollViewDidEndDecelerating(_:)`
    var didEndDeceleratingPublisher: AnyPublisher<Void, Never> {
        let selector = #selector(UIScrollViewDelegate.scrollViewDidEndDecelerating(_:))
        return self.proxy.intercept(selector)
            .eraseToAnyPublisher()
    }

    /// Combine wrapper for `scrollViewWillBeginDragging(_:)`
    var willBeginDraggingPublisher: AnyPublisher<Void, Never> {
        let selector = #selector(UIScrollViewDelegate.scrollViewWillBeginDragging(_:))
        return self.proxy.intercept(selector)
            .eraseToAnyPublisher()
    }

    /// Combine wrapper for `scrollViewWillEndDragging(_:withVelocity:targetContentOffset:)`
    var willEndDraggingPublisher: AnyPublisher<(velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>), Never> {
        let selector = #selector(UIScrollViewDelegate.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:))
        return self.proxy.intercept(selector)
            .map { values in
                let targetContentOffsetValue = values[2] as! NSValue
                let rawPointer = targetContentOffsetValue.pointerValue!

                return (values[1] as! CGPoint, rawPointer.bindMemory(to: CGPoint.self, capacity: MemoryLayout<CGPoint>.size))
            }
            .eraseToAnyPublisher()
    }

    /// Combine wrapper for `scrollViewDidEndDragging(_:willDecelerate:)`
    var didEndDraggingPublisher: AnyPublisher<Bool, Never> {
        let selector = #selector(UIScrollViewDelegate.scrollViewDidEndDragging(_:willDecelerate:))
        return self.proxy.intercept(selector).map { values in
            values[1] as? Bool ?? false
        }.eraseToAnyPublisher()
    }

    /// Combine wrapper for `scrollViewDidZoom(_:)`
    var didZoomPublisher: AnyPublisher<Void, Never> {
        let selector = #selector(UIScrollViewDelegate.scrollViewDidZoom(_:))
        return self.proxy.intercept(selector)
            .eraseToAnyPublisher()
    }

    /// Combine wrapper for `scrollViewDidScrollToTop(_:)`
    var didScrollToTopPublisher: AnyPublisher<Void, Never> {
        let selector = #selector(UIScrollViewDelegate.scrollViewDidScrollToTop(_:))
        return self.proxy.intercept(selector)
            .eraseToAnyPublisher()
    }

    /// Combine wrapper for `scrollViewDidEndScrollingAnimation(_:)`
    var didEndScrollingAnimationPublisher: AnyPublisher<Void, Never> {
        let selector = #selector(UIScrollViewDelegate.scrollViewDidEndScrollingAnimation(_:))
        return self.proxy.intercept(selector)
            .eraseToAnyPublisher()
    }
    
    /// Combine wrapper for `scrollViewWillBeginZooming(_:with:)`
    var willBeginZoomingPublisher: AnyPublisher<UIView?, Never> {
        let selector = #selector(UIScrollViewDelegate.scrollViewWillBeginZooming(_:with:))
        return self.proxy.intercept(selector).map { values in
            values[1] as? UIView
        }.eraseToAnyPublisher()
    }

    /// Combine wrapper for `scrollViewDidEndZooming(_:with:atScale:)`
    var didEndZooming: AnyPublisher<(view: UIView?, scale: CGFloat), Never> {
        let selector = #selector(UIScrollViewDelegate.scrollViewDidEndZooming(_:with:atScale:))
        return self.proxy.intercept(selector).map { values in
            (values[1] as? UIView, values[2] as? CGFloat ?? 0.0)
        }.eraseToAnyPublisher()
    }
    
    private var proxy: ScrollViewDelegateProxy {
        return .proxy(for: base,
                      setter: #selector(setter: base.delegate),
                      getter: #selector(getter: base.delegate))
    }
}

private class ScrollViewDelegateProxy: DelegateProxy<UIScrollViewDelegate>, UIScrollViewDelegate {
    @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
        forwardee?.scrollViewDidScroll?(scrollView)
    }
    
    @objc func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        forwardee?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    @objc func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        forwardee?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    @objc func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        forwardee?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    @objc func scrollViewDidZoom(_ scrollView: UIScrollView) {
        forwardee?.scrollViewDidZoom?(scrollView)
    }
    
    @objc func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        forwardee?.scrollViewDidScrollToTop?(scrollView)
    }
    
    @objc func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        forwardee?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    @objc func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        forwardee?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    @objc func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        forwardee?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
}

// swiftlint:enable force_cast
