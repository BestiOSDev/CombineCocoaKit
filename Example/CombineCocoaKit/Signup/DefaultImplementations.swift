//
//  DefaultImplementations.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Combine
import Foundation
import CombineCocoaKit

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}

class GitHubDefaultValidationService: GitHubValidationService {
    let API: GitHubAPI

    static let sharedValidationService = GitHubDefaultValidationService(API: GitHubDefaultAPI.sharedAPI)

    init(API: GitHubAPI) {
        self.API = API
    }

    // validation

    let minPasswordCount = 5

    func validateUsername(_ username: String) -> AnyPublisher<ValidationResult, Never> {
        if username.isEmpty {
            return CurrentValueRelay(value: .empty).eraseToAnyPublisher()
        }

        // this obviously won't be
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return CurrentValueRelay(value: .failed(message: "Username can only contain numbers or digits")).eraseToAnyPublisher()
        }

        return API.usernameAvailable(username).map { available in
            if available {
                return ValidationResult.ok(message: "Username available")
            }
            else {
                return ValidationResult.failed(message: "Username already taken")
            }
        }.eraseToAnyPublisher().eraseToAnyPublisher()
    }

    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.count
        if numberOfCharacters == 0 {
            return .empty
        }

        if numberOfCharacters < minPasswordCount {
            return .failed(message: "Password must be at least \(minPasswordCount) characters")
        }

        return .ok(message: "Password acceptable")
    }

    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        if repeatedPassword.count == 0 {
            return .empty
        }

        if repeatedPassword == password {
            return .ok(message: "Password repeated")
        }
        else {
            return .failed(message: "Password different")
        }
    }
}

class GitHubDefaultAPI: GitHubAPI {
    let shareSession: URLSession

    static let sharedAPI = GitHubDefaultAPI(
        URLSession: Foundation.URLSession.shared
    )

    init(URLSession: Foundation.URLSession) {
        self.shareSession = URLSession
    }

    func usernameAvailable(_ username: String) -> AnyPublisher<Bool, Never> {
        // this is ofc just mock, but good enough
        return AnyPublisher.create { subscriber in
            let url = URL(string: "https://github.com/\(username.URLEscaped)")!
            let request = URLRequest(url: url)
            let subscription = self.shareSession.dataTaskPublisher(for: request).sink { _ in

            } receiveValue: { (_: Data, response: URLResponse) in
                if (response as? HTTPURLResponse)?.statusCode == 404 {
                    subscriber.send(false)
                }
                else {
                    subscriber.send(true)
                }
                subscriber.send(completion: .finished)
            }
            return AnyCancellable {
                subscription.cancel()
            }
        }
    }

    func signup(_ username: String, password: String) -> AnyPublisher<Bool, Never> {
        // this is also just a mock
        let signupResult = arc4random() % 5 == 0 ? false : true
        return Just(signupResult)
            .delay(for: .seconds(1.0), scheduler: RunLoop.main, options: .none).eraseToAnyPublisher()
    }
}
