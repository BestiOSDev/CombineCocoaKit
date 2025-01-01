//
//  TestTextViewController.swift
//  LCombineExtension_Example
//
//  Created by dzb0409 on 2024/12/18.
//

import UIKit
import SnapKit
import CombineCocoaKit

class TestTextViewController: UIViewController {
    @Published var content: String = ""
    @Published var number: Int = 0
    lazy var cancellables: Set<AnyCancellable> = []
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .lightGray
        textView.font = .systemFont(ofSize: 16.0)
        textView.text = "Hello, World!"
        return textView
    }()
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .lightGray
        textField.font = .systemFont(ofSize: 16.0)
        textField.text = "Hello, World!"
        return textField
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TextView"
        self.view.backgroundColor = .white
        self.view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.height.equalTo(300.0)
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20.0)
        }
        textView.lx.value.sink { text in
            self.content = text
        }.store(in: &cancellables)
        textView.lx.didBeginEditing.sink { _ in
            debugPrint("textView didBeginEditing")
        }.store(in: &cancellables)

        textView.lx.didEndEditing.sink { _ in
            debugPrint("textView didEndEditing")
        }.store(in: &cancellables)

        textView.lx.didChange.sink { text in
            debugPrint("textView didChange text \(text)")
        }.store(in: &cancellables)

        textView.lx.didChangeSelection.sink { _ in
            debugPrint("textView didChange")
        }.store(in: &cancellables)
        
        self.view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200.0, height: 30.0))
            make.bottom.equalTo(textView.snp.top).offset(-100.0)
        }
        
        textField.lx.didBeginEditing.sink { _ in
            debugPrint("textfield didBeginEditing")
        }.store(in: &cancellables)
        
        textField.lx.didEndEditing.sink { _ in
            debugPrint("textfield didEndEditing")
        }.store(in: &cancellables)
        
        textField.lx.didChangeSelection.sink { _ in
            debugPrint("textfield didChangeSelection")
        }.store(in: &cancellables)
        
        textField.lx.value.sink { text in
            debugPrint("textfield didChange text \(text)")
        }.store(in: &cancellables)
        
        if #available(iOS 14.0, *) {
            (textField.lx.value <-> $content).store(in: &cancellables)
        }
        $content.sink { value in
            debugPrint("content \(value)")
        }.store(in: &cancellables)
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        textView.resignFirstResponder()
        textField.resignFirstResponder()
    }
    
}
