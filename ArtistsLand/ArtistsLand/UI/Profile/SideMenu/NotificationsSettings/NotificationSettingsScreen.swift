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
            LeftNavBarView(title: "Notifications Settings") {
                navigation.pop(animated: true)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    if viewModel.pushNotificationsStatus != .denied {
                        NotificationTopicView(isOn: $viewModel.isOn) {
                            viewModel.handleNotificationToggle()
                        }
                    } else {
                        AskForPushNotificationsView() {
                            viewModel.goToSettings()
                        }
                    }
                }.padding(.horizontal, 24)
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
                    let toast = Toast(text: "Edit successful!", textColor: Color.lightGreen)
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
            Text("Allow notifications")
                .font(.poppinsBold(size: 16))
                .foregroundStyle(Color.mainBlack)
            
            Text("This app does not have permission to send notifications. Please go to settings and activate notifications for this app.")
                .font(.poppinsRegular(size: 12))
                .foregroundStyle(Color.mainBlack)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
                
            BlueButtonView(text: "Go to settings") {
                action()
            }
        }.padding(.all, 20)
            .background(Color.mainGray)
            .cornerRadius(8, corners: .allCorners)
    }
}

struct NotificationTopicView: View {
    @Binding var isOn: Bool
    let action: () -> ()
    
    var body: some View {
        HStack {
            Text("Notifications")
                .font(.poppinsSemiBold(size: 20))
                .foregroundStyle(Color.mainBlack)
            
            Spacer()
            
            ToggleView(isOn: $isOn) {
                action()
            }
        }
    }
}
