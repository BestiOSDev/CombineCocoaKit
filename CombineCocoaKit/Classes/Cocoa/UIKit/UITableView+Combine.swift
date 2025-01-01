//
//  UITableView+Combine.swift
//  CombineCocoaKit
//
//  Created by dongzb01 on 2022/11/16.
//

import UIKit
import Combine

// swiftlint:disable force_cast
@available(iOS 13.0, *)
public extension LCombineXWrapper where Base: UITableView {
    private var proxy: TableViewDelegateProxy {
        return .proxy(for: base,
                      setter: #selector(setter: base.delegate),
                      getter: #selector(getter: base.delegate))
    }
    
    /// Combine wrapper for `tableView(_:willDisplay:forRowAt:)`
    var willDisplayCellPublisher: AnyPublisher<(cell: UITableViewCell, indexPath: IndexPath), Never> {
        let selector = #selector(UITableViewDelegate.tableView(_:willDisplay:forRowAt:))
        return self.proxy.intercept(selector).map { values in
            let cell = values[1] as? UITableViewCell ?? UITableViewCell()
            let indexPath = values[2] as? IndexPath ?? IndexPath()
            return (cell, indexPath)
        }.eraseToAnyPublisher()
    }
    
    /// Combine wrapper for `tableView(_:willDisplayHeaderView:forSection:)`
    var willDisplayHeaderViewPublisher: AnyPublisher<(headerView: UIView, section: Int), Never> {
        let selector = #selector(UITableViewDelegate.tableView(_:willDisplayHeaderView:forSection:))
        return self.proxy.intercept(selector).map { values in
            let view = values[1] as? UIView ?? UIView()
            let section = values[2] as? Int ?? 0
            return (view, section)
        }.eraseToAnyPublisher()
    }
    
    /// Combine wrapper for `tableView(_:willDisplayFooterView:forSection:)`
    var willDisplayFooterViewPublisher: AnyPublisher<(footerView: UIView, section: Int), Never> {
        let selector = #selector(UITableViewDelegate.tableView(_:willDisplayFooterView:forSection:))
        return self.proxy.intercept(selector).map { values in
            let view = values[1] as? UIView ?? UIView()
            let section = values[2] as? Int ?? 0
            return (view, section)
        }.eraseToAnyPublisher()
    }
    
    /// Combine wrapper for `tableView(_:didEndDisplaying:forRowAt:)`
    var didEndDisplayingCellPublisher: AnyPublisher<(cell: UITableViewCell, indexPath: IndexPath), Never> {
        let selector = #selector(UITableViewDelegate.tableView(_:didEndDisplaying:forRowAt:))
        return self.proxy.intercept(selector).map { values in
            let cell = values[1] as? UITableViewCell ?? UITableViewCell()
            let indexPath = values[2] as? IndexPath ?? IndexPath()
            return (cell, indexPath)
        }.eraseToAnyPublisher()
    }
    
    /// Combine wrapper for `tableView(_:didEndDisplayingHeaderView:forSection:)`
    var didEndDisplayingHeaderViewPublisher: AnyPublisher<(headerView: UIView, section: Int), Never> {
        let selector = #selector(UITableViewDelegate.tableView(_:didEndDisplayingHeaderView:forSection:))
        return self.proxy.intercept(selector).map { values in
            let view = values[1] as? UIView ?? UIView()
            let section = values[2] as? Int ?? 0
            return (view, section)
        }.eraseToAnyPublisher()
    }
    
    /// Combine wrapper for `tableView(_:didEndDisplayingFooterView:forSection:)`
    var didEndDisplayingFooterViewPublisher: AnyPublisher<(footerView: UIView, section: Int), Never> {
        let selector = #selector(UITableViewDelegate.tableView(_:didEndDisplayingFooterView:forSection:))
        return self.proxy.intercept(selector).map { values in
            let view = values[1] as? UIView ?? UIView()
            let section = values[2] as? Int ?? 0
            return (view, section)
        }.eraseToAnyPublisher()
    }
    
    /// Combine wrapper for `tableView(_:accessoryButtonTappedForRowWith:)`
    var itemAccessoryButtonTappedPublisher: AnyPublisher<IndexPath, Never> {
        let selector = #selector(UITableViewDelegate.tableView(_:accessoryButtonTappedForRowWith:))
        return self.proxy.intercept(selector).map { values in
            let indexPath = values[1] as? IndexPath ?? IndexPath()
            return indexPath
        }.eraseToAnyPublisher()
    }
    
    /// Combine wrapper for `tableView(_:didHighlightRowAt:)`
    var didHighlightRowPublisher: AnyPublisher<IndexPath, Never> {
        let selector = #selector(UITableViewDelegate.tableView(_:didHighlightRowAt:))
        return self.proxy.intercept(selector).map { values in
            let indexPath = values[1] as? IndexPath ?? IndexPath()
            return indexPath
        }.eraseToAnyPublisher()
    }
    
    /// Combine wrapper for `tableView(_:didUnHighlightRowAt:)`
    var didUnhighlightRowPublisher: AnyPublisher<IndexPath, Never> {
        let selector = #selector(UITableViewDelegate.tableView(_:didUnhighlightRowAt:))
        return self.proxy.intercept(selector).map { values in
            let indexPath = values[1] as? IndexPath ?? IndexPath()
            return indexPath
        }.eraseToAnyPublisher()
    }
    
    /// Combine wrapper for `tableView(_:didSelectRowAt:)`
    var didSelectRowPublisher: AnyPublisher<IndexPath, Never> {
        let selector = #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))
        return self.proxy.intercept(selector).map { values in
            let indexPath = values[1] as? IndexPath ?? IndexPath()
            return indexPath
        }.eraseToAnyPublisher()
    }
    
    /// Combine wrapper for `tableView(_:didDeselectRowAt:)`
    var didDeselectRowPublisher: AnyPublisher<IndexPath, Never> {
        let selector = #selector(UITableViewDelegate.tableView(_:didDeselectRowAt:))
        return self.proxy.intercept(selector).map { values in
            let indexPath = values[1] as? IndexPath ?? IndexPath()
            return indexPath
        }.eraseToAnyPublisher()
    }
    
    /// Combine wrapper for `tableView(_:willBeginEditingRowAt:)`
    var willBeginEditingRowPublisher: AnyPublisher<IndexPath, Never> {
        let selector = #selector(UITableViewDelegate.tableView(_:willBeginEditingRowAt:))
        return self.proxy.intercept(selector).map { values in
            let indexPath = values[1] as? IndexPath ?? IndexPath()
            return indexPath
        }.eraseToAnyPublisher()
    }
    
    /// Combine wrapper for `tableView(_:didEndEditingRowAt:)`
    var didEndEditingRowPublisher: AnyPublisher<IndexPath, Never> {
        let selector = #selector(UITableViewDelegate.tableView(_:didEndEditingRowAt:))
        return self.proxy.intercept(selector).map { values in
            let indexPath = values[1] as? IndexPath ?? IndexPath()
            return indexPath
        }.eraseToAnyPublisher()
    }
    
    var heightForRowAtPublisher: AnyPublisher<IndexPath, Never> {
        let selector = #selector(UITableViewDelegate.tableView(_:heightForRowAt:))
        return self.proxy.intercept(selector).map { values in
            let indexPath = values[1] as? IndexPath ?? IndexPath()
            return indexPath
        }.eraseToAnyPublisher()
    }
}

private class TableViewDelegateProxy: DelegateProxy<UITableViewDelegate>, UITableViewDelegate {
    @objc func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        forwardee?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    @objc func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        forwardee?.tableView?(tableView, willDisplayHeaderView: view, forSection: section)
    }
    
    @objc func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        forwardee?.tableView?(tableView, willDisplayFooterView: view, forSection: section)
    }
    
    @objc func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        forwardee?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    @objc func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        forwardee?.tableView?(tableView, didEndDisplayingHeaderView: view, forSection: section)
    }
    
    @objc func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        forwardee?.tableView?(tableView, didEndDisplayingFooterView: view, forSection: section)
    }
    
    @objc func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        forwardee?.tableView?(tableView, didHighlightRowAt: indexPath)
    }
    
    @objc func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        forwardee?.tableView?(tableView, accessoryButtonTappedForRowWith: indexPath)
    }
    
    @objc func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        forwardee?.tableView?(tableView, didUnhighlightRowAt: indexPath)
    }
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        forwardee?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    @objc func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        forwardee?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    @objc func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        forwardee?.tableView?(tableView, willBeginEditingRowAt: indexPath)
    }
    
    @objc func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        forwardee?.tableView?(tableView, didEndEditingRowAt: indexPath)
    }
    
    @objc func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return forwardee?.tableView?(tableView, heightForRowAt: indexPath) ?? 0
    }
}

// swiftlint:enable force_cast
