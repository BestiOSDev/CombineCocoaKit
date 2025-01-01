//
//  GithubSignupViewModel1.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Combine
import UIKit

/**
This is example where view model is mutable. Some consider this to be MVVM, some consider this to be Presenter,
 or some other name.
 In the end, it doesn't matter.
 
 If you want to take a look at example using "immutable VMs", take a look at `TableViewWithEditingCommands` example.
 
 This uses vanilla rx observable sequences.
 
 Please note that there is no explicit state, outputs are defined using inputs and dependencies.
 Please note that there is no dispose bag, because no subscription is being made.
*/
class GithubSignupViewModel1 {
    // outputs {

    let validatedUsername: AnyPublisher<ValidationResult, Never>
    let validatedPassword: AnyPublisher<ValidationResult, Never>
    let validatedPasswordRepeated: AnyPublisher<ValidationResult, Never>
//
    // Is signup button enabled
    let signupEnabled: AnyPublisher<Bool, Never>

    // Has user signed in
    let signedIn: AnyPublisher<Bool, Never>
    init(input: (
        username: AnyPublisher<String, Never>,
        password: AnyPublisher<String, Never>,
        repeatedPassword: AnyPublisher<String, Never>,
        loginTaps: AnyPublisher<UIButton, Never>
    ),
    dependency: (
        API: GitHubAPI,
        validationService: GitHubValidationService
    )) {
        let API = dependency.API
        let validationService = dependency.validationService
        validatedUsername = input.username.flatMap { username in
            validationService.validateUsername(username)
        }.eraseToAnyPublisher()
        validatedPassword = input.password.map { password in
            validationService.validatePassword(password)
        }.eraseToAnyPublisher()
        validatedPasswordRepeated = [input.password, input.repeatedPassword].combineLatest().map { values in
            validationService.validateRepeatedPassword(values[0], repeatedPassword: values[1])
        }.eraseToAnyPublisher()
        let usernameAndPassword = input.username.combineLatest(input.password)
        self.signedIn = input.loginTaps.flatMap { _ in
            let a = usernameAndPassword.flatMap { username, password in
                API.signup(username, password: password)
            }.eraseToAnyPublisher()
            return a
        }
        .removeDuplicates()
        .eraseToAnyPublisher()
            
        signupEnabled = validatedUsername.combineLatest(validatedPassword, validatedPasswordRepeated).map { username, password, repeatPassword in
            username.isValid &&
                password.isValid &&
                repeatPassword.isValid
        }.eraseToAnyPublisher()
    }
}
