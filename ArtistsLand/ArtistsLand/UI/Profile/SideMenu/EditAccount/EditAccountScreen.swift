//
//  EditAccountScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 06.11.2024.
//

import SwiftUI

struct EditAccountScreen: View {
    @StateObject var viewModel: EditAccountViewModel
    @EnvironmentObject private var navigation: Navigation
    
    @State var changesMade: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            LeftNavBarView(title: "Edit account") {
                if changesMade == true {
                    let modal = ModalChooseOptionView(title: "Are you sure?",
                                                      description: "If you leave this page, your changes won't be saved.",
                                                      topButtonText: "Leave",
                                                      bottomButtonText: "Stay") {
                        navigation.dismissModal(animated: true, completion: nil)
                        navigation.pop(animated: true)
                    } onBottomButtonTapped: {
                        navigation.dismissModal(animated: true, completion: nil)
                    }

                    navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                } else {
                    navigation.pop(animated: true)
                }
            }
            
            if !viewModel.isLoading {
                VStack(spacing: 12) {
                    FloatingField(text: $viewModel.email,
                                  placeHolder: "Email",
                                  leftIcon: .icFieldEmail,
                                  errorMessage: viewModel.errorMessageEmail)
                    
                    FloatingField(text: $viewModel.nickname,
                                  placeHolder: "Username",
                                  leftIcon: .icFieldAccount,
                                  errorMessage: viewModel.errorMessageName)
                    
                    
                }.padding(.horizontal, 16)
                    .padding(.top, 20)
                
                Spacer(minLength: 80)
                
                MainBlueButtonView(text: "Save Changes", isDisabled: changesMade ? false : true) {
                    viewModel.editInfo()
                }.padding(.horizontal, 16)
                    .padding(.bottom, 32)
            } else {
                Spacer()
                LoaderView()
                Spacer()
            }
        }.background(Color.mainWhite)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .onChange(of: viewModel.nickname) { _, _ in
                changesMade = true
                viewModel.errorMessageName = nil
            }
            .onChange(of: viewModel.email) { _, _ in
                changesMade = true
                viewModel.errorMessageEmail = nil
            }
            .onReceive(viewModel.eventSubject) { event in
                switch event {
                case .completed:
                    navigation.pop(animated: true)
                    ToastManager.instance.show(
                        Toast(
                            text: "Edit successful!",
                            textColor: Color.lightGreen
                        ))
                case .error:
                    let modal = ModalChooseOptionView(title: "Something went wrong",
                                                      description: "An error has occured and we couldn't complete the action. Please try again later.",
                                                      topButtonText: "Back") {
                        navigation.dismissModal(animated: true, completion: nil)
                    }
                    navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                }
            }
    }
}

