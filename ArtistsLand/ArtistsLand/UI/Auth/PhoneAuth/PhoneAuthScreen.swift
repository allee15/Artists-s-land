//
//  PhoneAuthScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.12.2024.
//

import SwiftUI

struct PhoneAuthScreen: View {
    @StateObject var viewModel: PhoneAuthViewModel
    @EnvironmentObject private var navigation: Navigation
    @FocusState var focusedField: OtpField?
    
    var body: some View {
        VStack(spacing: 20) {
            NavBarView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    Text("Please enter a phone number in order to activate 2 factor-authentication. Note that we will not share your phone number with anyone else.")
                        .foregroundStyle(Color.mainBlack)
                        .font(.poppinsRegular(size: 16))
                    
                    BlueButtonView(text: "Open Passwords") {
                        viewModel.openGoogleAuthApp()
                    }
                    
                    FloatingField(text: $viewModel.otpCode,
                                  placeHolder: "OTP Code",
                                  keyboardType: .phonePad,
                                  leftIcon: .icPhone)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .codeSend)
                    
                    MainBlueButtonView(text: "Verify code", isDisabled: viewModel.otpCode.isEmpty) {
                        viewModel.verifyCode()
                    }
                    
                }.padding(.top, 12)
                    .padding(.horizontal, 16)
            }
        }.background(Color.mainBlue)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(viewModel.verifyCodeCompletion) { event in
                switch event {
                case .completed:
                    navigation.pop(animated: true)
                    ToastManager.instance.show(
                        Toast(
                            text: "Code verified successfully!",
                            textColor: Color.lightGreen
                        ))
                case .error:
                    let modal = ModalChooseOptionView(title: "Error",
                                          description: "An error has occured. Please try again.",
                                                      topButtonText: "Try again") {
                        navigation.dismissModal(animated: true, completion: nil)
                    }
                    navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                }
            }
    }
}
