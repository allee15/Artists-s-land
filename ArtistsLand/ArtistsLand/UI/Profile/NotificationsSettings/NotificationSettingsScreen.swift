//
//  NotificationSettingsScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 22.10.2024.
//

import SwiftUI

struct NotificationsSettingsScreen: View {
    @StateObject private var viewModel = NotificationsSettingsViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        VStack(spacing: 0) {
            LeftNavBarView(title: "Setări notificări") {
                navigation.pop(animated: true)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    if viewModel.pushNotificationsStatus != .denied {
                        HStack {
                            Text("da subscribe")
                            Spacer()
                            Button {
                                viewModel.handleNotificationToggle()
                            } label: {
                                Image(viewModel.isOn ? .icCheckedOn : .icCheckedOff)
                            }.frame(width: 44, height: 24)
                        }
                    } else {
                        AskForPushNotificationsView() {
                            viewModel.goToSettings()
                        }
                    }
                }.padding(.horizontal, 16)
                    .padding(.top, 32)
            }
        }.background(Color.mainWhite)
            .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                viewModel.watchStatus()
            }
            .onReceive(viewModel.notificationSettingsEvent) { event in
                switch event {
                case .completed:
                    let toast = Toast(text: "da", textColor: Color.lightGreen)
                    ToastManager.instance.show(toast)
                case .notificationsDenied:
                    break
                }
            }
    }
}

struct AskForPushNotificationsView: View {
    let action: () -> ()
    
    var body: some View {
        VStack(spacing: 12) {
//            Image(.icFooterCampaign)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(height: 80)
            
            Text("Activează notificările")
                .font(.poppinsBold(size: 16))
                .foregroundStyle(Color.mainBlack)
            
            Text("Aplicația nu are permisiunea de a trimite notificări. Te rugăm să mergi la setările aplicației pentru a activa notificările.")
                .font(.poppinsRegular(size: 12))
                .foregroundStyle(Color.mainBlack)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
                
            BlueButtonView(text: "Mergi la setări") {
                action()
            }
        }.padding(.all, 20)
            .background(Color.gray)
            .cornerRadius(8, corners: .allCorners)
    }
}
