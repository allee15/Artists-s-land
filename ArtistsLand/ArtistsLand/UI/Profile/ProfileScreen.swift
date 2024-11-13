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
    @State private var showAddPhotoBottomSheet: Bool = false
    private let mainNavigation = EnvironmentObjects.navigation
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    VStack(spacing: 20) {
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
                                        AddProfilePhotoView(title: "Add profile photo", 
                                                            buttonText: "Delete avatar",
                                                            selectedImage: $viewModel.profileImage,
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
                        
                        DividerView()
                    }
                    
                    if viewModel.isLoading {
                        LoaderView()
                    } else if let user = viewModel.userInfo {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 20) {
                                BlueButtonView(text: "Add new post") {
                                    self.showAddPhotoBottomSheet = true
                                }.sheet(isPresented: $showAddPhotoBottomSheet) {
                                    AddProfilePhotoView(title: "Add new post to your account",
                                                        buttonText: "Add photo",
                                                        selectedImage: $viewModel.newPostImage,
                                                        hideBottomSheet: $showAddPhotoBottomSheet) { deleteAvatar in
                                        viewModel.postImage()
                                        self.showAddPhotoBottomSheet = false
                                    }
                                }
                                
                                ForEach(user.posts, id: \.id) { post in
                                    PostView(post: post, showName: false) { postLiked in
                                        viewModel.likePost(postId: post.id)
                                    } commentsAction: { comment in
                                        viewModel.addCommentToPost(comment: comment, postId: post.id)
                                    } nameAction: { id in
                                        
                                    }
                                }
                            }.padding(.bottom, 20)
                                .padding(.horizontal, 16)
                        }
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
            .onReceive(viewModel.eventSubjectForImages) { event in
                switch event {
                case .sent:
                    ToastManager.instance.show(
                        Toast(
                            text: "Edit successful!",
                            textColor: Color.lightGreen
                        ))
                    
                case .failed:
                    let toast = Toast(text: "An error has occured. Please try again!", textColor: Color.lightRed)
                    ToastManager.instance.show(toast)
                }
            }
    }
}
