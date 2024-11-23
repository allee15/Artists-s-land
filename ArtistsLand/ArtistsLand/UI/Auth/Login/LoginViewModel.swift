//
//  LoginViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import Foundation
import Combine

enum LoginCompletion {
    case login
    case failure(Error)
}

enum Field {
    case email
    case password
}

class LoginViewModel: BaseViewModel {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessageEmail: String?
    @Published var errorMessagePassword: String?
    
    let loginCompletion = PassthroughSubject<LoginCompletion, Never>()
    var userService = UserService.shared
    
    func login() {
        if email.isValidEmail() {
            userService.login(email: email, password: password)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard let self else { return }
                    switch completion {
                    case .failure(let error):
                        self.loginCompletion.send(.failure(error))
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] user in
                    guard let self else { return }
                    self.loginCompletion.send(.login)
                }
                .store(in: &bag)
        } else {
            if password.isEmpty {
                self.errorMessagePassword = "Please enter a valid password."
            } else if password.count < 6 {
                self.errorMessagePassword = "Password must contain at least 6 characters."
            }
            self.errorMessageEmail = "Please enter a valid email address."
        }
    }
}
