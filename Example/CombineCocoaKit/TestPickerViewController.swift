//
//  TestPickerViewController.swift
//  LCombineExtension_Example
//
//  Created by dzb0409 on 2024/12/17.
//

import UIKit
import Combine

class TestPickerViewController: UIViewController {
    private lazy var cancellables: Set<AnyCancellable> = []
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PickerView"
        self.view.backgroundColor = .white
        self.view.addSubview(pickerView)
        pickerView.frame = CGRect(x: 0, y: 100.0, width: self.view.frame.size.width, height: 500.0)
        pickerView.lx.didSelect.sink { row, component in
            debugPrint("pickerView.cx.didSelect \(row) \(component)")
        }.store(in: &cancellables)
    }
}

extension TestPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        100
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(row)"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        debugPrint("didSelectRow \(row) inComponent \(component)")
    }
}
