//
//  PhoneAuthViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.12.2024.
//

import SwiftUI
import Combine

enum OtpField {
    case codeSend
}

enum VerifyCodeCompletion {
    case completed
    case error
}

class PhoneAuthViewModel: BaseViewModel {
    private var userService = UserService.shared
    
    @Published var otpauthURL: String?
    @Published var id: String
    @Published var otpCode: String = ""

    let verifyCodeCompletion = PassthroughSubject<VerifyCodeCompletion, Never>()
    
    init(otpauthURL: String?, id: String) {
        self.otpauthURL = otpauthURL
        self.id = id
    }
    
    func openGoogleAuthApp() {
        guard let otpauthURL = otpauthURL, let url = URL(string: otpauthURL) else {
            print("Invalid OTPAUTH URL")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func verifyCode() {
        userService.verifyCode(code: otpCode, id: id)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] result in
                guard let self else { return }
                if result {
                    self.verifyCodeCompletion.send(.completed)
                } else {
                    self.verifyCodeCompletion.send(.error)
                }
            }.store(in: &bag)
    }
}
