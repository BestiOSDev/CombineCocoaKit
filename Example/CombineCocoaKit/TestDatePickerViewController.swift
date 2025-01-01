//
//  TestDatePickerViewController.swift
//  LCombineExtension_Example
//
//  Created by dzb0409 on 2024/12/17.
//

import UIKit
import Combine

class TestDatePickerViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []
    @Published var date: Date = Date()
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
        }
        return datePicker
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "DatePicker"
        self.view.backgroundColor = .white
        self.view.addSubview(datePicker)
        datePicker.frame = CGRect(x: 0, y: 300.0, width: self.view.frame.width, height: 200)
        datePicker.lx.date.sink { date in
            self.label.text = date.description
        }.store(in: &cancellables)
        
        datePicker.lx.countDownDuration.sink { duration in
            debugPrint("duration:\(duration)")
        }.store(in: &cancellables)
        
        self.view.addSubview(label)
        label.frame = CGRect(x: 0, y: 500.0, width: self.view.frame.width, height: 200)
        
        $date.bind(to: datePicker.lx.date).store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.date = Date().addingTimeInterval(86400.0)
        }
    }
    

}
