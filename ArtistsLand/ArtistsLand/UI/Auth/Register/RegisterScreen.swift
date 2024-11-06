//
//  RegisterScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import SwiftUI

struct RegisterScreen: View {
    @StateObject var viewModel = RegisterViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    @FocusState var focusedField: RegisterField?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            NavBarView()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Let’s create your account")
                        .font(.poppinsBold(size: 28))
                        .foregroundStyle(Color.mainBlueButton)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 20)
                    
                    Text("Please enter your details below")
                        .font(.poppinsRegular(size: 14))
                        .foregroundStyle(Color.mainBlueButton)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 24)
                    
                    VStack(spacing: 12) {
                        FloatingField(text: $viewModel.name,
                                      placeHolder: "Username",
                                      leftIcon: .icFieldAccount,
                                      errorMessage: viewModel.errorMessageName)
                        .submitLabel(.next)
                        .focused($focusedField, equals: .name)
                        
                        SelectAccountTypeView(gender: $viewModel.selectedUserType,
                                         gendersList: viewModel.userType,
                                         errorMessage: viewModel.errorMessageUserType)
                        
                        FloatingField(text: $viewModel.email,
                                      placeHolder: "Email address",
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
                        .submitLabel(.done)
                        .focused($focusedField, equals: .password)
                        
                        HStack(alignment: .top) {
                            Toggle(isOn: $viewModel.showGreeting) {
                                Group {
                                    Text("I read and agree to ")
                                        .foregroundColor(Color.mainBlueButton)
                                    + Text("The Terms and Conditions")
                                        .underline()
                                        .foregroundColor(Color.mainBlueButton)
                                    
                                }.font(.poppinsRegular(size: 14))
                                    .onTapGesture {
                                        let webview = WebViewScreen(
                                            title: "Terms and Conditions",
                                            url: URL(string: "https://www.termsandconditionsgenerator.com/live.php?token=PiVV3ZACQYyqXIbXBFFhQMDNtBY90XBx")!
                                        ).asDestination()
                                        navigation.push(webview, animated: true)
                                    }
                            }.toggleStyle(CheckboxToggleStyle())
                            Spacer()
                        }
                        
                        if let error = viewModel.errorMessageToggle {
                            HStack {
                                Text(error)
                                    .font(.poppinsRegular(size: 12))
                                    .foregroundColor(Color.lightRed)
                                Spacer()
                            }
                            .padding(.top, 4)
                        }
                        
                        BlueButtonView(text: "Create account") {
                            viewModel.allFieldAreCompleted()
                        }
                    }
                }.padding(.top, 24)
                    .padding(.horizontal, 16)
            }
        }.background(Color.mainBlue)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: viewModel.name) { _, newValue in
                viewModel.errorMessageName = nil
            }
            .onChange(of: viewModel.selectedUserType) { _, newValue in
                viewModel.errorMessageUserType = nil
            }
            .onChange(of: viewModel.email) { _, newValue in
                viewModel.errorMessageEmail = nil
            }
            .onChange(of: viewModel.password) { _, newValue in
                viewModel.errorMessagePassword = nil
            }
            .onChange(of: viewModel.showGreeting) { _, newValue in
                viewModel.errorMessageToggle = nil
            }
            .onReceive(viewModel.registerCompletion) { registerCompletion in
                switch registerCompletion {
                case .failure(_):
                    let modal = ModalChooseOptionView(title: "Error",
                                          description: "An error has occured. Please try again.",
                                                      topButtonText: "Try again") {
                        navigation.dismissModal(animated: true, completion: nil)
                    }
                    navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                case .register:
                    navigation.replaceNavigationStack([TabBarScreen().asDestination()], animated: true)
                }
            }
    }
}

fileprivate struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(configuration.isOn ? "ic_checked_on" : "ic_checked_off")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.simpleBlue)
                .frame(width: 28, height: 28)
                .onTapGesture { configuration.isOn.toggle() }
            configuration.label
        }
    }
}
