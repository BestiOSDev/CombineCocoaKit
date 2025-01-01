//
//  LoginViewModel.swift
//  LCombineExtension_Example
//
//  Created by dongzb01 on 2022/8/4.
//

import Foundation
import Combine

class LoginViewModel {
    var userName: String = ""
    var password: String = ""
    var cancelables: Set<AnyCancellable> = []
    init(userName: AnyPublisher<String, Never>, password: AnyPublisher<String, Never>) {
        self.usernameValid = userName.map { text -> Bool in
            return text.count >= 8
        }.eraseToAnyPublisher()
        self.passwordValid = password.map { _text -> Bool in
            return _text.count >= 4
        }.eraseToAnyPublisher()
        
        everythingValid = usernameValid.combineLatest(passwordValid).map({ val1, val2 -> Bool in
            return val1 && val2
        }).eraseToAnyPublisher()
        
        userName.assign(to: \.userName, on: self).store(in: &cancelables)
        password.assign(to: \.password, on: self).store(in: &cancelables)
    }
    
    var usernameValid: AnyPublisher<Bool, Never>
    var passwordValid: AnyPublisher<Bool, Never>
    var everythingValid: AnyPublisher<Bool, Never>

}
