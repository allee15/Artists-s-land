//
//  PhoneAuthScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.12.2024.
//

import SwiftUI

struct PhoneAuthScreen: View {
    @StateObject private var viewModel = PhoneAuthViewModel()
    @FocusState var focusedField: OtpField?
    @EnvironmentObject private var navigation: Navigation
    let action: () -> ()
    
    var body: some View {
        VStack(spacing: 20) {
            NavBarView()
            
            Text("Please enter a phone number in order to activate 2 factor-authentication. Note that we will not share your phone number with anyone else.")
                .foregroundStyle(Color.mainBlack)
                .font(.poppinsRegular(size: 16))
                .padding(.horizontal, 16)
            
            if !viewModel.isCodeSent {
                FloatingField(text: $viewModel.phoneNumber,
                              placeHolder: "Phone number",
                              keyboardType: .phonePad,
                              leftIcon: .icPhone,
                              errorMessage: viewModel.errorMessage)
                .padding(.horizontal, 16)
                .submitLabel(.next)
                .focused($focusedField, equals: .codeSend)
                
            } else {
                FloatingField(text: $viewModel.otpCode,
                              placeHolder: "Otp code",
                              keyboardType: .numberPad,
                              errorMessage: viewModel.errorMessage)
                .padding(.horizontal, 16)
                .submitLabel(.done)
                .focused($focusedField, equals: .codeVerified)
            }
            
            MainBlueButtonView(text: !viewModel.isCodeSent ? "Send code" : "Verify code") {
                if !viewModel.isCodeSent {
                    viewModel.sendVerificationCode()
                } else {
                    viewModel.verifyCode()
                }
            }.padding(.horizontal, 16)
            
            Spacer()
        }.background(Color.mainBlue)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(viewModel.eventSubject) { event in
                switch event {
                case .codeSend:
                    break
                case .codeVerified:
                    action()
                }
            }
            .onChange(of: viewModel.otpCode) { oldValue, newValue in
                viewModel.errorMessage = nil
            }
            .onChange(of: viewModel.phoneNumber) { oldValue, newValue in
                viewModel.errorMessage = nil
            }
    }
}
