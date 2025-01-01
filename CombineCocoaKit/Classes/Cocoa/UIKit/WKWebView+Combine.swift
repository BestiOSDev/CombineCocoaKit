//
//  WKWebView+Combine.swift
//  Pods
//
//  Created by dzb0409 on 2024/12/18.
//
import WebKit
import Combine

@available(iOS 13.0, *)
extension WKWebView: LCombineXCompatible { }

@available(iOS 13.0, *)
public extension LCombineXWrapper where Base: WKWebView {
    private var proxy: WKWebViewNavigationDelegate {
        return .proxy(for: base,
                      setter: #selector(setter: base.navigationDelegate),
                      getter: #selector(getter: base.navigationDelegate))
    }
    
    /// Reactive wrapper for `navigationDelegate` message.
    var didCommit: AnyPublisher<WKNavigation, Never> {
        let selector = #selector(WKNavigationDelegate.webView(_:didCommit:))
        return self.proxy.intercept(selector).map { values in
            values[1] as? WKNavigation ?? WKNavigation()
        }.eraseToAnyPublisher()
    }
    
    /// Reactive wrapper for `navigationDelegate` message.
    var didStartLoad: AnyPublisher<WKNavigation, Never> {
        let selector = #selector(WKNavigationDelegate.webView(_:didStartProvisionalNavigation:))
        return self.proxy.intercept(selector).map { values in
            values[1] as? WKNavigation ?? WKNavigation()
        }.eraseToAnyPublisher()
    }

    /// Reactive wrapper for `navigationDelegate` message.
    var didFinishLoad: AnyPublisher<WKNavigation, Never> {
        let selector = #selector(WKNavigationDelegate.webView(_:didFinish:))
        return self.proxy.intercept(selector).map { values in
            values[1] as? WKNavigation ?? WKNavigation()
        }.eraseToAnyPublisher()
    }

    /// Reactive wrapper for `navigationDelegate` message.
    var didFailLoad: AnyPublisher<(WKNavigation, Error), Never> {
        let selector = #selector(WKNavigationDelegate.webView(_:didFailProvisionalNavigation:withError:))
        return self.proxy.intercept(selector).map { values in
            let navigation = values[1] as? WKNavigation ?? WKNavigation()
            let error = values[2] as? Error ?? NSError(domain: "未知错误", code: 0, userInfo: nil)
            return (navigation, error)
        }.eraseToAnyPublisher()
    }
}

@available(iOS 13.0, *)
private class WKWebViewNavigationDelegate: DelegateProxy<WKNavigationDelegate>, WKNavigationDelegate {
    @objc func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        forwardee?.webView?(webView, didCommit: navigation)
    }
    
    @objc func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        forwardee?.webView?(webView, didStartProvisionalNavigation: navigation)
    }
    
    @objc func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        forwardee?.webView?(webView, didFinish: navigation)
    }
    
    @objc func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        forwardee?.webView?(webView, didFailProvisionalNavigation: navigation, withError: error)
    }
}
