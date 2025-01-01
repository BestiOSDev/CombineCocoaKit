//
//  TableTableViewController.swift
//  LCombineExtension_Example
//
//  Created by dongzb01 on 2022/8/4.
//

import UIKit
import Combine
import SnapKit
import CombineCocoaKit

class TableViewController: UIViewController {
    
    var cancelables: Set<AnyCancellable> = []
    let tableView = UITableView(frame: .zero, style: .grouped)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TableViewController"
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "kCellIdentifier")
        registerPublisher()
    }
    
    func registerPublisher() {
        self.tableView.lx.willDisplayCellPublisher.sink { (cell, indexPath) in
            debugPrint("willDisplayCellPublisher cell.textLabel.text = \(cell.textLabel?.text ?? "")")
        }.store(in: &self.cancelables)
        
        self.tableView.lx.willDisplayHeaderViewPublisher.sink { (headerView: UIView, section: Int) in
            headerView.backgroundColor = .red
            debugPrint("headerView = \(headerView), section = \(section)")
        }.store(in: &cancelables)
        
        self.tableView.lx.willDisplayFooterViewPublisher.sink { (footerView: UIView, section: Int) in
            footerView.backgroundColor = .yellow
            debugPrint("footerView = \(footerView), section = \(section)")
        }.store(in: &cancelables)
        
        self.tableView.lx.didEndDisplayingCellPublisher.sink { (cell: UITableViewCell, indexPath: IndexPath) in
            cell.backgroundColor = .white
            debugPrint("didEndDisplayingCellPublisher cell.textLabel.text = \(cell.textLabel?.text ?? "")")
        }.store(in: &cancelables)
        
        self.tableView.lx.didEndDisplayingHeaderViewPublisher.sink { (headerView: UIView, section: Int) in
            debugPrint("didEndDisplayingHeaderViewPublisher")
        }.store(in: &cancelables)
        
        self.tableView.lx.didEndDisplayingFooterViewPublisher.sink { (headerView: UIView, section: Int) in
            debugPrint("didEndDisplayingFooterViewPublisher")
        }.store(in: &cancelables)
        
        self.tableView.lx.heightForRowAtPublisher.sink { (indexPath: IndexPath)  in
            debugPrint("heightForRowAtPublisher")
        }.store(in: &cancelables)
        // 修复单例类使用同一个publisher， 多次订阅时 无法相应 receiveValue 事件
        SingletonClass.shared.publisher.sink { value in
            print("TableViewController1 \(value)")
        }.store(in: &cancelables)
        SingletonClass.shared.publisher.sink { value in
            print("TableViewController2 \(value)")
        }.store(in: &cancelables)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kCellIdentifier")
        cell?.textLabel?.text = "IndexPath.row = \(indexPath.row)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 50.0))
        label.text = "footer \(section)"
        return label
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 50.0))
        label.text = "header \(section)"
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SingletonClass.shared.publisher.accept(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        debugPrint("willDisplayHeaderView")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        debugPrint("willDisplay cell")
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        debugPrint("willDisplayFooterView")
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .white
    }
    
}

