//
//  SideMenuScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 06.11.2024.
//

import SwiftUI

struct SideMenuScreen: View {
    @EnvironmentObject private var navigation: Navigation
    @StateObject private var viewModel = SideMenuViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            LeftNavBarView(title: "Profile menu") {
                navigation.pop(animated: true)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    if let user = viewModel.userInfo {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Account")
                                .font(.poppinsSemiBold(size: 16))
                                .foregroundStyle(Color.mainBlack)
                                .padding(.horizontal, 16)
                            
                            WidgetView(title: "Edit account", icon: .icEditaccount) {
                                let vm = EditAccountViewModel(userInfo: user)
                                navigation.push(EditAccountScreen(viewModel: vm).asDestination(),
                                                animated: true)
                            }
                            
                            WidgetView(title: "Change password", icon: .icChangePassword) {
                                navigation.push(ChangePasswordScreen().asDestination(),
                                                animated: true)
                            }
                            
                            if user.isArtist {
                                WidgetView(title: "Wallet", icon: .icWallet) {
                                    navigation.push(WalletScreen().asDestination(),
                                                    animated: true)
                                }
                            }
                            
                            WidgetView(title: "Logout", icon: .icLogout) {
                                let modal = ModalChooseOptionView(title: "Are you sure you want to logout?",
                                                                  description: "You will not have access to your chats if you are logged out.",
                                                                  topButtonText: "Logout",
                                                                  bottomButtonText: "Cancel") {
                                    viewModel.logOut()
                                    navigation.dismissModal(animated: true, completion: nil)
                                } onBottomButtonTapped: {
                                    navigation.dismissModal(animated: true, completion: nil)
                                }
                                
                                navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                            }
                            
                            WidgetView(title: "Delete account", icon: .icDeleteAccount) {
                                let modal = ModalChooseOptionView(title: "Are you sure you want to delete your account?",
                                                                  description: "You will not be able to recover it after deleting it. All your data will be lost, including your chats.",
                                                                  topButtonText: "Delete my account",
                                                                  bottomButtonText: "Cancel") {
                                    viewModel.deleteAccount()
                                    navigation.dismissModal(animated: true, completion: nil)
                                } onBottomButtonTapped: {
                                    navigation.dismissModal(animated: true, completion: nil)
                                }
                                
                                navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Settings")
                            .font(.poppinsSemiBold(size: 16))
                            .foregroundStyle(Color.mainBlack)
                            .padding(.horizontal, 16)
                        
                        WidgetView(title: "App settings", icon: .icAppSettings) {
                            navigation.push(ThemeSettingsScreen().asDestination(), animated: true)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Legal")
                            .font(.poppinsSemiBold(size: 16))
                            .foregroundStyle(Color.mainBlack)
                            .padding(.horizontal, 16)
                        
                        WidgetView(title: "Terms and Conditions", icon: .icTerms) {
                            let webview = WebViewScreen(
                                title: "Terms and Conditions",
                                url: URL(string: "https://www.termsfeed.com/live/17f439a6-a867-421c-a8d0-909a50670747")!
                            ).asDestination()
                            navigation.push(webview, animated: true)
                        }
                        
                        WidgetView(title: "Contact us", icon: .icContactus) {
                            let email = "alexia.elena.aldea@gmail.com"
                            let urlString = "mailto:\(email)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            
                            if let url = URL(string: urlString ?? "") {
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Language")
                            .font(.poppinsSemiBold(size: 16))
                            .foregroundStyle(Color.mainBlack)
                            .padding(.horizontal, 16)
                        
                        WidgetView(title: "Change language", icon: .icChangeLanguage) {
                            let appSettingsURL = URL(string: UIApplication.openSettingsURLString)!
                                .appendingPathComponent(Bundle.main.bundleIdentifier!)
                            if URL(string: UIApplication.openSettingsURLString) != nil {
                                UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
                            }
                        }
                    }
                    
                    WidgetView(title: "App version \(viewModel.appVersion)", icon: .icAppVersion, showToggle: false) {}
                }.padding(.top, 20)
                    .padding(.bottom, 32)
            }
        }.background(Color.mainWhite)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .onReceive(viewModel.eventSubject) { eventSubject in
                switch eventSubject {
                case .logout:
                    navigation.dismissModal(animated: true, completion: nil)
                    navigation.push(LoginScreen().asDestination(), animated: true)
                    
                case .failure:
                    let modal = ModalChooseOptionView(title: "Something went wrong",
                                                      description: "An error has occured and we couldn't complete the action. Please try again later.",
                                                      topButtonText: "Back") {
                        navigation.dismissModal(animated: true, completion: nil)
                    }
                    navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                    
                case .delete:
                    navigation.dismissModal(animated: true, completion: nil)
                    ToastManager.instance.show(
                        Toast(
                            text: "Account deleted successfully!",
                            textColor: Color.lightGreen
                        ))
                    navigation.push(LoginScreen().asDestination(), animated: true)
                }
            }
    }
}

fileprivate struct WidgetView: View {
    let title: String
    let icon: ImageResource
    var showToggle: Bool = true
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                Image(icon)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.mainBlack)
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .font(.poppinsRegular(size: 16))
                    .foregroundColor(.mainBlack)
                
                Spacer()
                
                if showToggle {
                    Image(.icItemresultArrow)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.mainBlack)
                }
            }.padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.mainGray)
                .padding(.horizontal, 16)
        }
    }
}
