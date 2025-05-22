//
//  LoginScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import SwiftUI

struct LoginScreen: View {
    @StateObject var viewModel = LoginViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    @FocusState var focusedField: Field?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavBarView(isCloseButton: true)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Access your Artist's land account")
                        .font(.poppinsBold(size: 32))
                        .foregroundStyle(Color.mainBlack)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 38)
                    
                    FloatingField(text: $viewModel.email,
                                  placeHolder: "Email address",
                                  keyboardType: .emailAddress,
                                  leftIcon: .icFieldEmail,
                                  errorMessage: viewModel.errorMessageEmail)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .email)
                    .onSubmit {
                        focusedField = .password
                    }
                    
                    FloatingField(text: $viewModel.password,
                                  placeHolder: "Password",
                                  secureField: true,
                                  leftIcon: .icFieldPassword,
                                  errorMessage: viewModel.errorMessagePassword)
                        .padding(.top, 12)
                        .submitLabel(.done)
                        .focused($focusedField, equals: .password)
                    
                    BlueButtonView(text: "Log in") {
                        viewModel.login()
                    }.padding(.top, 12)
                }.padding(.top, 24)
                    .padding(.horizontal, 16)
            }
            
        }.background(Color.mainWhite)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: [.horizontal, .bottom])
            .safeAreaInset(edge: .bottom, content: {
                MainBlueButtonView(text: "Create an Account") {
                    navigation.push(RegisterScreen().asDestination(), animated: true)
                }.padding(.bottom, 16)
                    .padding(.horizontal, 16)
            })
            .onChange(of: viewModel.email) { _, newValue in
                viewModel.errorMessageEmail = nil
            }
            .onChange(of: viewModel.password) { _, newValue in
                viewModel.errorMessagePassword = nil
            }
            .onReceive(viewModel.loginCompletion) { loginCompletion in
            switch loginCompletion {
            case .failure(_), .invalidCredentials:
                let modal = ModalChooseOptionView(title: "Error",
                                      description: "An error has occured. Please try again.",
                                                  topButtonText: "Try again") {
                    navigation.dismissModal(animated: true, completion: nil)
                }
                navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
            case .login(let url, let id, let isTwoFactorEnabled):
                if isTwoFactorEnabled {
                    let vm = PhoneAuthViewModel(otpauthURL: url, id: id)
                    navigation.push(PhoneAuthScreen(viewModel: vm).asDestination(), animated: true)
                } else {
                    break
                }
            }
        }
    }
}
