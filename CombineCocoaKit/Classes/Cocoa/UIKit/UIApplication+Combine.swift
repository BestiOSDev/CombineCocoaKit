//
//  UIApplication+Combine.swift
//  Pods
//
//  Created by dzb0409 on 2024/12/16.
//

import UIKit
import Combine

@available(iOS 13.0, *)
extension UIApplication: LCombineXCompatible { }

@available(iOS 13.0, *)
extension LCombineXWrapper where Base: UIApplication {
    
    /// Reactive wrapper for `UIApplication.didEnterBackgroundNotification`
    public var didEnterBackground: AnyPublisher<Notification, Never> {
        return NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification, object: nil).eraseToAnyPublisher()
    }
    
    /// Reactive wrapper for `UIApplication.willEnterForegroundNotification`
    public var willEnterForeground: AnyPublisher<Notification, Never> {
        return NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification, object: nil).eraseToAnyPublisher()
    }
    
    /// Reactive wrapper for `UIApplication.didFinishLaunchingNotification`
    public var didFinishLaunching: AnyPublisher<Notification, Never> {
        return NotificationCenter.default.publisher(for: UIApplication.didFinishLaunchingNotification, object: nil).eraseToAnyPublisher()
    }
    
    /// Reactive wrapper for `UIApplication.didBecomeActiveNotification`
    public var didBecomeActive: AnyPublisher<Notification, Never> {
        return NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification, object: nil).eraseToAnyPublisher()
    }
    
    /// Reactive wrapper for `UIApplication.willResignActiveNotification`
    public var willResignActive: AnyPublisher<Notification, Never> {
        return  NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification, object: nil).eraseToAnyPublisher()
    }
    
    /// Reactive wrapper for `UIApplication.didReceiveMemoryWarningNotification`
    public var didReceiveMemoryWarning: AnyPublisher<Notification, Never> {
        return  NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification, object: nil).eraseToAnyPublisher()
    }
    
    /// Reactive wrapper for `UIApplication.willTerminateNotification`
    public var willTerminate: AnyPublisher<Notification, Never>  {
        return  NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification, object: nil).eraseToAnyPublisher()
    }
    
    
    /// Reactive wrapper for `UIApplication.significantTimeChangeNotification`
    public  var significantTimeChange: AnyPublisher<Notification, Never>  {
        return  NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification, object: nil).eraseToAnyPublisher()
    }
    
    /// Reactive wrapper for `UIApplication.backgroundRefreshStatusDidChangeNotification`
    public var backgroundRefreshStatusDidChange: AnyPublisher<Notification, Never>  {
        return  NotificationCenter.default.publisher(for: UIApplication.backgroundRefreshStatusDidChangeNotification, object: nil).eraseToAnyPublisher()
    }
    
    /// Reactive wrapper for `UIApplication.protectedDataWillBecomeUnavailableNotification`
    public var protectedDataWillBecomeUnavailable: AnyPublisher<Notification, Never>  {
        return  NotificationCenter.default.publisher(for: UIApplication.protectedDataWillBecomeUnavailableNotification, object: nil).eraseToAnyPublisher()
    }
    
    /// Reactive wrapper for `UIApplication.protectedDataDidBecomeAvailableNotification`
    public var protectedDataDidBecomeAvailable: AnyPublisher<Notification, Never>  {
        return  NotificationCenter.default.publisher(for: UIApplication.protectedDataDidBecomeAvailableNotification, object: nil).eraseToAnyPublisher()
    }
    
    /// Reactive wrapper for `UIApplication.userDidTakeScreenshotNotification`
    public var userDidTakeScreenshot: AnyPublisher<Notification, Never>  {
        return  NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification, object: nil).eraseToAnyPublisher()
    }
    
}
