//
//  ArtistProfileScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 11.11.2024.
//

import SwiftUI

struct ArtistProfileScreen: View {
    @StateObject var viewModel: ArtistProfileViewModel
    @EnvironmentObject private var navigation: Navigation
    private let mainNavigation = EnvironmentObjects.navigation
    
    var body: some View {
        VStack(spacing: 0) {
            LeftNavBarView(title: "Posts") {
                navigation.pop(animated: true)
            }
            
            switch viewModel.artistInfoState {
            case .loading:
                VStack {
                    Spacer()
                    LoaderView()
                    Spacer()
                }
            case .failure:
                VStack {
                    Spacer()
                    Text("An error has occured. Please try again!")
                        .font(.poppinsSemiBold(size: 20))
                        .foregroundStyle(Color.mainBlack)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 12)
                    
                    ClearButton(text: "Try again") {
                        viewModel.getArtistInfo()
                    }
                    Spacer()
                }
            case .value(let artistInfo):
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        AccountSummaryView(profileImage: artistInfo.avatarUrl,
                                           name: artistInfo.nickname) { }
                        
                        BlueButtonView(text: "Send message") {
                            if viewModel.user != nil {
                                viewModel.createChat()
                            } else {
                                viewModel.eventSubject.send(.notLoggedIn)
                            }
                        }.padding(.vertical, 8)
                        
                        switch viewModel.artistPostState {
                        case .failure(_):
                            VStack {
                                Spacer()
                                Text("An error has occured. Please try again!")
                                    .font(.poppinsSemiBold(size: 20))
                                    .foregroundStyle(Color.mainBlack)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 12)
                                
                                ClearButton(text: "Try again") {
                                    viewModel.getArtistPosts()
                                }
                                Spacer()
                            }
                        case .loading:
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    LoaderView()
                                    Spacer()
                                }
                                Spacer()
                            }
                        case .value(let posts):
                            ForEach(posts, id: \.id) { post in
                                PostView(post: post, showName: false, canDeletePost: true) { postLiked in
                                    if postLiked {
                                        viewModel.likePost(postId: post.id)
                                    } else {
                                        viewModel.unlikePost(postId: post.id)
                                    }
                                } commentsAction: { comment in
                                    viewModel.addCommentToPost(comment: comment, postId: post.id,
                                                               artistName: artistInfo.nickname)
                                } nameAction: { id in
                                    
                                } deleteAction: { canDelete, post in
                                    if !canDelete {
                                        viewModel.reportPost(postId: post.id)
                                    }
                                }
                            }
                        }
                    }.padding(.vertical, 20)
                        .padding(.horizontal, 16)
                }
            }
        }.onReceive(viewModel.eventSubject) { event in
            switch event {
            case .created:
                navigation.popToRoot(animated: true)
                TabBarCoordinator.instance.shouldGetChats = true
                TabBarCoordinator.instance.tabBarNavigation = .chats
                
            case .failed:
                let toast = Toast(text: "An error has occured. Please try again!", textColor: Color.lightRed)
                ToastManager.instance.show(toast)
                
            case .notLoggedIn:
                let modal = ModalChooseOptionView(title: "You're not logged in!",
                                                  description: "In order to start a new chat, or to send a message, you have to log in to your account.",
                                                  topButtonText: "Login",
                                                  bottomButtonText: "Close") {
                    navigation.dismissModal(animated: true, completion: nil)
                    mainNavigation?.push(LoginScreen().asDestination(), animated: true)
                } onBottomButtonTapped: {
                    navigation.dismissModal(animated: true, completion: nil)
                }
                
                navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                
            case .reportSent:
                let modal = ModalChooseOptionView(title: "Report sent",
                                                  description: "Thank you for your report! We will look into it as soon as possible.",
                                                  topButtonText: "Close",
                                                  onTopButtonTapped: {
                    navigation.dismissModal(animated: true, completion: nil)
                })
                
                navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
            }
        }
    }
}
