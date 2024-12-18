//
//  PhoneAuthViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.12.2024.
//

import SwiftUI
import Combine
import FirebaseAuth

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
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            if let error = error {
                self?.errorMessage = "Eroare la trimiterea codului: \(error.localizedDescription)"
                print("Eroare: \(error.localizedDescription)")
                return
            }
            
            self?.verificationID = verificationID
            self?.isCodeSent = true
            self?.eventSubject.send(.codeSend)
            print("Codul a fost trimis!")
        }
    }
    
    func verifyCode() {
        errorMessage = nil
        
        guard let verificationID = verificationID else {
            errorMessage = "Nu există un ID de verificare."
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otpCode)
        
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = "Eroare la verificarea codului: \(error.localizedDescription)"
                print("Eroare: \(error.localizedDescription)")
                return
            }
            
            self?.eventSubject.send(.codeVerified)
            print("Cod verificat și utilizator autentificat!")
        }
    }
}
