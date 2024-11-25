//
//  ChangePasswordViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 06.11.2024.
//

import Foundation
import Combine

enum ChangePasswordField {
    case currentPassword
    case newPassword
    case confirmNewPassword
}

enum ChangePasswordCompletion {
    case completed
    case error
}

class ChangePasswordViewModel: BaseViewModel {
    var userService = UserService.shared
    
    @Published var actualPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmNewPassword: String = ""
    @Published var errorMessageConfirmNewPassword: String?
    @Published var errorMessagePassword: String?
    let eventSubject = PassthroughSubject<ChangePasswordCompletion, Never>()
    
    func changePassword() {
        if newPassword.count < 6 {
            self.errorMessagePassword = "Password must contain at least 6 characters."
        } else if newPassword != confirmNewPassword {
            self.errorMessageConfirmNewPassword = "Passwords do not match!"
        } else {
            userService.changePassword(newPassword: newPassword, currentPassword: actualPassword)
                .sink { _ in
                    
                } receiveValue: { [weak self] response in
                    guard let self else {return}
                    if response {
                        self.eventSubject.send(.completed)
                    } else {
                        self.eventSubject.send(.error)
                    }
                }.store(in: &bag)
        }
    }
}

