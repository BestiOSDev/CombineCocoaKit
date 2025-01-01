//
//  TestUIControlViewController.swift
//  LCombineExtension_Example
//
//  Created by dzb0409 on 2024/12/17.
//

import UIKit
import Combine
import CombineCocoaKit

class TestUIControlViewController: UIViewController {
    @Published var progress: Float = 0.0
    @Published var isLoading: Bool = true
    @Published var selectIndex: Int = 0
    private var timer: Timer?
    private lazy var progressView: UIProgressView = .init(progressViewStyle: .default)
    private var activityView: UIActivityIndicatorView = .init(style: .large)
    private var cancellables: Set<AnyCancellable> = []
    lazy var yellowButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.setTitleColor(.green, for: .normal)
        button.setTitle("黄色按钮", for: .normal)
        return button
    }()
    lazy var redButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.setTitle("红色按钮", for: .normal)
        return button
    }()
    @Published var buttonEnabled: Bool = false
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        return switchControl
    }()
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["红", "黄", "绿"])
        segmentedControl.selectedSegmentIndex = 1
        return segmentedControl
    }()
    lazy var silder: UISlider = {
        let view = UISlider()
        view.minimumValue = 0
        view.maximumValue = 1.0
        view.maximumTrackTintColor = .blue
        view.minimumTrackTintColor = .lightGray
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "UIControl"
        self.view.backgroundColor = .white
        
        self.view.addSubview(yellowButton)
        yellowButton.frame = CGRect(x: 100, y: 150, width: 100, height: 50)
        yellowButton.lx.controlEvent(.touchUpInside).sink { button in
            debugPrint("controlEvent")
        }.store(in: &cancellables)
        
        yellowButton.lx.tapPublisher.sink { button in
            debugPrint("tapPublisher")
        }.store(in: &cancellables)
        
//      let bind1 = yellowButton.lx.title
        let bind1 = yellowButton.lx.title(for: .normal)
        Just("按钮1").bind(to: bind1).store(in: &cancellables)
        
//      let bind2 = yellowButton.lx.image
        let bind2 = yellowButton.lx.image(for: .normal)
        Just(UIImage(systemName: "square.and.arrow.up")).bind(to: bind2).store(in: &cancellables)
        
        
        self.view.addSubview(redButton)
        redButton.frame = CGRect(x: 100, y: 250, width: 100, height: 50)
        redButton.lx.tapPublisher.sink { button in
            debugPrint("红色按钮被点击了")
        }.store(in: &cancellables)
        
        $buttonEnabled.bind(to: redButton.lx.isEnabled).store(in: &cancellables)
        $buttonEnabled.map { flag in
            flag ? UIColor.green : UIColor.red
        }
        .bind(to: redButton.lx.backgroundColor)
        .store(in: &cancellables)
                
        self.view.addSubview(activityView)
        activityView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        $isLoading.bind(to: activityView.lx.isAnimating).store(in: &cancellables)
        
        self.view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(redButton.snp.bottom).offset(100.0)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 300.0, height: 5.0))
        }
        progressView.progressTintColor = .blue
        progressView.trackTintColor = .lightGray
        $progress.bind(to: progressView.lx.progress).store(in: &cancellables)
        
        self.view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(progressView.snp.bottom).offset(100.0)
        }
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if self.progress < 1.0 {
                self.progress += 0.01
            } else {
                self.isLoading = false
                self.buttonEnabled = true
                self.timer?.invalidate()
                self.timer = nil
            }
        }
        RunLoop.main.add(timer, forMode: .common)
        timer.fire()
        self.timer = timer
        
        segmentedControl.lx.selectedSegmentIndex.sink { index in
            if index == 0 {
                self.view.backgroundColor = .red
            } else if index == 1 {
                self.view.backgroundColor = .yellow
            } else {
                self.view.backgroundColor = .green
            }
        }.store(in: &cancellables)
        
        Just("red").bind(to: segmentedControl.lx.titleForSegment(at: 0)).store(in: &cancellables)
        Just(UIImage.init(systemName: "degreesign.celsius")).bind(to: segmentedControl.lx.imageForSegment(at: 2)).store(in: &cancellables)
        
        self.view.addSubview(switchControl)
        switchControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(segmentedControl.snp.bottom).offset(50.0)
        }
        switchControl.lx.isOn.sink { isOn in
            debugPrint("isOn \(isOn)")
        }.store(in: &cancellables)
        
        if #available(iOS 14.0, *) {
            (switchControl.lx.isOn <-> $buttonEnabled).store(in: &cancellables)
        }
        self.view.addSubview(silder)
        silder.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200.0, height: 50.0))
            make.top.equalTo(switchControl.snp.bottom).offset(50.0)
        }
        silder.lx.value.sink { value in
            debugPrint("value \(value)")
        }.store(in: &cancellables)
        silder.lx.twoBind(keyPath: \.value, to: $progress).store(in: &cancellables)
        if #available(iOS 14.0, *) {
            (segmentedControl.lx.selectedSegmentIndex <-> $selectIndex).store(in: &cancellables)
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.invalidate()
        self.timer = nil
    }
    

}
