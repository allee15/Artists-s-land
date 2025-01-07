//
//  PhoneAuthViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.12.2024.
//

import SwiftUI
import Combine

enum OtpCompletion {
    case codeSend
    case codeVerified
}

enum OtpField {
    case codeSend
    case codeVerified
}

class PhoneAuthViewModel: BaseViewModel {
    var userService = UserService.shared
    
    @Published var phoneNumber: String = ""
    @Published var otpCode: String = ""
    @Published var isCodeSent: Bool = false
    @Published var errorMessage: String?
    
    private var verificationID: String?
    
    let eventSubject = PassthroughSubject<OtpCompletion, Never>()
    
    func sendVerificationCode() {
        errorMessage = nil
        isCodeSent = false
    }
    
    func verifyCode() {
        
    }
}
