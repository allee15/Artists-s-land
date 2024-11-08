//
//  ProfileScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import SwiftUI

struct ProfileScreen: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showChangePhotoBottomSheet: Bool = false
    private let mainNavigation = EnvironmentObjects.navigation
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    HStack(alignment: .top) {
                        if let userInfo = viewModel.userInfo {
                            if !viewModel.isLoading {
                                AccountSummaryView(profileImage: userInfo.avatarUrl,
                                                   name: userInfo.nickname) {
                                    self.showChangePhotoBottomSheet = true
                                }.onChange(of: viewModel.profileImage) { _, _ in
                                    viewModel.updateProfileImage(id: userInfo.id)
                                    self.showChangePhotoBottomSheet = false
                                }
                                .sheet(isPresented: $showChangePhotoBottomSheet) {
                                    AddProfilePhotoView(selectedImage: $viewModel.profileImage,
                                                        hideBottomSheet: $showChangePhotoBottomSheet) { deleteAvatar in
                                        if deleteAvatar {
                                            viewModel.updateProfileImage(id: userInfo.id, shouldDeleteAvatar: deleteAvatar)
                                            self.showChangePhotoBottomSheet = false
                                        }
                                    }
                                }
                            } else {
                                Spacer()
                                LoaderView()
                            }
                        } else {
                            AccountSummaryView(profileImage: "",
                                               name: "") { }
                        }
                        Spacer()
                        
                        SideButtonView(icon: .icSideMenu) {
                            mainNavigation?.push(SideMenuScreen().asDestination(), animated: true)
                        }
                    }.padding(.horizontal, 16)
                        .padding(.top, 20)
                    
                    if viewModel.isLoading {
                        LoaderView()
                    } else {
                        
                    }
                }
            }
        }.ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.mainWhite)
            .onReceive(viewModel.eventSubject) { event in
                switch event {
                case .completed:
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
