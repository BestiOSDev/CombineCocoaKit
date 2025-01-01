//
//  TestWebViewController.swift
//  LCombineExtension_Example
//
//  Created by dzb0409 on 2024/12/18.
//

import UIKit
import SnapKit
import WebKit
import CombineCocoaKit

class TestWebViewController: UIViewController {
    private lazy var cancellables: Set<AnyCancellable> = []
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WebView"
        self.view.backgroundColor = .white
        self.view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        webView.load(URLRequest(url: URL(string: "https://www.baidu.com")!))
        webView.lx.didCommit.sink { navigation in
            debugPrint("webView didCommit")
        }.store(in: &cancellables)
        
        webView.lx.didStartLoad.sink { navigation in
            debugPrint("webView didStartLoad")
        }.store(in: &cancellables)
        
        webView.lx.didFinishLoad.sink { navigation in
            debugPrint("webView didFinishLoad")
        }.store(in: &cancellables)
        
        webView.lx.didFailLoad.sink { navigation, error in
            debugPrint("webView didFailLoad error \(error)")
        }.store(in: &cancellables)
        
    }
    
}
