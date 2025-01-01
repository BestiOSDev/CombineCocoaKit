//
//  GitHubSignupViewController1.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 4/25/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import UIKit
import CombineCocoaKit

class GitHubSignupViewController1 : ViewController {
    private var cancelables: [AnyCancellable] = []
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidationOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidationOutlet: UILabel!
    
    @IBOutlet weak var repeatedPasswordOutlet: UITextField!
    @IBOutlet weak var repeatedPasswordValidationOutlet: UILabel!
    
    @IBOutlet weak var signupOutlet: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = nil
        let viewModel = GithubSignupViewModel1(
            input: (
                username: usernameOutlet.lx.value.asObservable(),
                password: passwordOutlet.lx.value.asObservable(),
                repeatedPassword: repeatedPasswordOutlet.lx.value.asObservable(),
                loginTaps: signupOutlet.lx.tapPublisher
            ),
            dependency: (
                API: GitHubDefaultAPI.sharedAPI,
                validationService: GitHubDefaultValidationService.sharedValidationService
            )
        )
                
        viewModel.signupEnabled
            .receive(on: RunLoop.main)
            .sink {[weak self] valid in
            self?.signupOutlet.isEnabled = valid
            self?.signupOutlet.alpha = valid ? 1.0 : 0.5
        }.store(in: &cancelables)

        viewModel.validatedUsername
            .bind(to: usernameValidationOutlet.lx.validationResult)
            .store(in: &cancelables)

        viewModel.validatedPassword
            .bind(to: passwordValidationOutlet.lx.validationResult)
            .store(in: &cancelables)
        viewModel.validatedPasswordRepeated
            .bind(to: repeatedPasswordValidationOutlet.lx.validationResult)
            .store(in: &cancelables)

        viewModel.signedIn.sink { signedIn in
            let alertVC = UIAlertController(title: "温馨提示", message: "User signed in \(signedIn)", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "取消", style: .cancel))
            self.present(alertVC, animated: true)
        }.store(in: &cancelables)

        let tapBackground = UITapGestureRecognizer()
        tapBackground.lx.tapPublisher.sink {[weak self] _ in
            self?.view.endEditing(true)
        }.store(in: &cancelables)
        view.addGestureRecognizer(tapBackground)
        
    }
}
