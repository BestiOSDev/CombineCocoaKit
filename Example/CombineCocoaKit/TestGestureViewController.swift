//
//  TestGestureViewController.swift
//  LCombineExtension_Example
//
//  Created by dzb0409 on 2024/12/17.
//

import UIKit
import Combine
import SnapKit
import CombineCocoaKit

class TestGestureViewController: UIViewController {
    private lazy var cancelables: [AnyCancellable] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TestGestureViewController"
        self.view.backgroundColor = .white
        
        let redView = UIView()
        redView.backgroundColor = .red
        self.view.addSubview(redView)
        redView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(100.0)
            make.size.equalTo(CGSize(width: 100.0, height: 100.0))
        }
        
        let tap1 = UITapGestureRecognizer()
        tap1.lx.tapPublisher.sink { _ in
            debugPrint("tapPublisher action")
        }.store(in: &cancelables)
        redView.addGestureRecognizer(tap1)
        
        let yellowView = UIView()
        yellowView.backgroundColor = .yellow
        self.view.addSubview(yellowView)
        yellowView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(redView.snp.bottom).offset(100.0)
            make.size.equalTo(CGSize(width: 200.0, height: 200.0))
        }
        
        let longTap1 = UILongPressGestureRecognizer()
        longTap1.lx.longPressPublisher.sink { _ in
            debugPrint("longPressPublisher action")
        }.store(in: &cancelables)
        yellowView.addGestureRecognizer(longTap1)
        
        
        let pinch1 = UIPinchGestureRecognizer()
        pinch1.lx.pinchPublisher.sink { _ in
            debugPrint("pinchPublisher action")
        }.store(in: &cancelables)
        yellowView.addGestureRecognizer(pinch1)

    }
    
}
