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
        
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    HStack(alignment: .top) {
                        if let userInfo = viewModel.userInfo {
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
                            AccountSummaryView(profileImage: "",
                                               name: "") { }
                        }
                        Spacer()
                        
                        SideButtonView(icon: .icSideMenu) {
                            mainNavigation?.push(SideMenuScreen().asDestination(), animated: true)
                        }
                    }.padding(.horizontal, 16)
                        .padding(.top, 20)
                }
            }
        }.ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.mainWhite)
    }
}
