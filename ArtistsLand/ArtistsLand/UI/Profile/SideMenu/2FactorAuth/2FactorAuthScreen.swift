//
//  2FactorAuthScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 09.01.2025.
//

import SwiftUI

struct FactorAuthScreen: View {
    @StateObject var viewModel: FactorAuthViewModel
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        VStack(spacing: 0) {
            LeftNavBarView(title: "Two Factor Authentication") {
                navigation.pop(animated: true)
            }
            
            HStack {
                Text(viewModel.isOn ? "Deactivate two factor authentication" : "Activate two factor authentication")
                    .font(.poppinsRegular(size: 16))
                    .foregroundStyle(Color.mainBlack)
                
                Spacer()
                
                ToggleView(isOn: $viewModel.isOn) {
                    viewModel.change2faStatus()
                }
            }.padding(.horizontal, 16)
                .padding(.top, 32)
            
            Spacer()
        }.background(Color.mainWhite)
            .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(viewModel.eventSubject) { event in
                switch event {
                case .completed:
                    ToastManager.instance.show(
                        Toast(
                            text: "Change made successfully!",
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
