//
//  LoginViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import Foundation
import Combine

enum LoginCompletion {
    case login(String, String, Bool)
    case invalidCredentials
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
    
    func allFieldAreCompleted() {
        if !email.isValidEmail() {
            self.errorMessageEmail = "Please enter a valid email address."
        }
        
        if password.isEmpty {
            self.errorMessagePassword = "This field is required."
        } else if password.count < 6 {
            self.errorMessagePassword = "Password must contain at least 6 characters."
        }
        
        if errorMessageEmail == nil && errorMessagePassword == nil {
            self.login()
        }
    }
    
    func login() {
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
                if user.user.email.isEmpty {
                    self.loginCompletion.send(.invalidCredentials)
                } else {
                    self.loginCompletion.send(.login(user.authKey, user.user.id, user.user.isTwoFactorEnabled))
                }
            }
            .store(in: &bag)
    }
}
