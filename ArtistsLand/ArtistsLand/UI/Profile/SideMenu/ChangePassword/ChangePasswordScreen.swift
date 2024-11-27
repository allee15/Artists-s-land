//
//  ChangePasswordScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 06.11.2024.
//

import SwiftUI

struct ChangePasswordScreen: View {
    @StateObject private var viewModel = ChangePasswordViewModel()
    @EnvironmentObject private var navigation: Navigation
    @FocusState var focusedField: ChangePasswordField?
    
    var body: some View {
        VStack(spacing: 0) {
            LeftNavBarView(title: "Change password") {
                navigation.pop(animated: true)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 8) {
                    FloatingField(text: $viewModel.actualPassword,
                                  placeHolder: "Actual password",
                                  secureField: true)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .currentPassword)
                    .onSubmit {
                        focusedField = .newPassword
                    }
                    
                    FloatingField(text: $viewModel.newPassword,
                                  placeHolder: "New password",
                                  secureField: true,
                                  errorMessage: viewModel.errorMessagePassword)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .newPassword)
                    .onSubmit {
                        focusedField = .confirmNewPassword
                    }
                    
                    FloatingField(text: $viewModel.confirmNewPassword,
                                  placeHolder: "Confirm new password",
                                  secureField: true,
                                  errorMessage: viewModel.errorMessageConfirmNewPassword)
                    .focused($focusedField, equals: .confirmNewPassword)
                    
                    Text("Choose a new password. Note that it should be at least 6 characters.")
                        .foregroundStyle(Color.mainBlack)
                        .font(.poppinsRegular(size: 14))
                    
                }.padding(.horizontal, 16)
                    .padding(.top, 20)
            }
        }.background(Color.mainWhite)
            .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom, content: {
                VStack(spacing: 8) {
                    MainBlueButtonView(text: "Save new password") {
                        viewModel.changePassword()
                    }
                    
                    ClearButton(text: "Close") {
                        navigation.pop(animated: true)
                    }
                }.padding(.horizontal, 16)
                    .padding(.bottom, 12)
            })
            .onTapGesture {
                hideKeyboard()
            }
            .onChange(of: viewModel.newPassword) { _, newValue in
                viewModel.errorMessagePassword = nil
            }
            .onChange(of: viewModel.confirmNewPassword) { _, newValue in
                viewModel.errorMessageConfirmNewPassword = nil
            }
            .onReceive(viewModel.eventSubject) { event in
                switch event {
                case .completed:
                    navigation.pop(animated: true)
                    let toast = Toast(text: "Edit successful!", textColor: Color.lightGreen)
                    ToastManager.instance.show(toast)
                case .error:
                    navigation.pop(animated: true)
                    let toast = Toast(text: "An error has occured. Please try again!", textColor: Color.lightRed)
                    ToastManager.instance.show(toast)
                }
            }
    }
}
