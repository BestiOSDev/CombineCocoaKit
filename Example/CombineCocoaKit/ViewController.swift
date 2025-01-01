//
//  ViewController.swift
//  LCombineExtesion
//
//  Created by dongzb01 on 07/27/2022.
//  Copyright (c) 2022 dongzb01. All rights reserved.
//

import UIKit
import SnapKit
import CombineCocoaKit

class ViewController: UIViewController {
    private let dataArray: [String] = ["UIControl+Combine", "UIDatePicker+Combine", "UIGestureRecognizer+Combine", "UIScrollView+Combine", "UITableView+Combine", "UITextView+Combine", "UIPickerView+Combine", "UIImageVeiw+Combine", "WKWebView+Combine", "ImagePicker+Combine", "Github+MVVM注册"]
    @IBOutlet weak var tableView: UITableView!
    private var cancellables: Set<AnyCancellable> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        let addItem = UIBarButtonItem(image: UIImage(systemName: "pencil.tip.crop.circle.badge.plus.fill"), style: .plain, target: nil, action: nil)
        addItem.lx.tapPublisher.sink { _ in
            debugPrint("addItem action")
        }.store(in: &cancellables)
        self.navigationItem.rightBarButtonItem = addItem
        SingletonClass.shared.publisher.sink { value in
            print("ViewController \(value)")
        }.store(in: &cancellables)
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
    }
    
    func registerNotification() {
        UIApplication.shared.lx.didBecomeActive.sink { notification in
            debugPrint("didBecomeActive \(notification)")
        }.store(in: &cancellables)
        
        UIApplication.shared.lx.didEnterBackground.sink { notification in
            debugPrint("didEnterBackground \(notification)")
        }.store(in: &cancellables)
        
        UIApplication.shared.lx.willEnterForeground.sink { notification in
            debugPrint("willEnterForeground \(notification)")
        }.store(in: &cancellables)
        
        UIApplication.shared.lx.willResignActive.sink { notification in
            debugPrint("willResignActive \(notification)")
        }.store(in: &cancellables)
        
        UIApplication.shared.lx.didReceiveMemoryWarning.sink { notification in
            debugPrint("didReceiveMemoryWarning \(notification)")
        }.store(in: &cancellables)
        
        UIApplication.shared.lx.willTerminate.sink { notification in
            debugPrint("willTerminate \(notification)")
        }.store(in: &cancellables)
    }
    
    func subscribePublishSubject() {
        self.tableView.lx.didScrollPublisher.sink { _ in
            debugPrint("tableView didScrollPublisher")
        }.store(in: &cancellables)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "kCellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "kCellIdentifier")
        }
        cell?.textLabel?.text = dataArray[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        debugPrint("indexPath: \(indexPath)")
        if indexPath.row == 0 {
            let vc = TestUIControlViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = TestDatePickerViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc = TestGestureViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc = ScrollViewTestViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 4 {
            let tableVC = TableViewController()
            tableVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(tableVC, animated: true)
        } else if indexPath.row == 5 {
            let vc = TestTextViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 6 {
            let vc = TestPickerViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 7 {
            let vc = TestImageViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 8 {
            let vc = TestWebViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 9 {
            let imagepickerVC = ImagePickerController()
            imagepickerVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(imagepickerVC, animated: true)
        } else if indexPath.row == 10 {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "GitHubSignupViewController1") as? GitHubSignupViewController1 else { return  }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
