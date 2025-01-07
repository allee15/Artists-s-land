//
//  HomeScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        VStack(spacing: 0) {
            LeftNavBarView(title: "Artists land", hasBackButton: false) {}
            
            switch viewModel.postsState {
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
                        viewModel.loadPosts()
                    }
                    Spacer()
                }
            case .value(let posts):
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(posts, id: \.id) { post in
                            PostView(post: post) { postLiked in
                                if postLiked {
                                    viewModel.likePost(postId: post.id)
                                } else {
                                    viewModel.unlikePost(postId: post.id)
                                }
                            } commentsAction: { comment in
                                viewModel.addCommentToPost(comment: comment, postId: post.id)
                            } nameAction: { id in
                                let vm = ArtistProfileViewModel(artistId: String(id))
                                navigation.push(ArtistProfileScreen(viewModel: vm).asDestination(), animated: true)
                            } deleteAction: { canDelete, post in
                                if !canDelete {
                                    viewModel.reportPost(postId: post.id)
                                }
                            }

                        }
                    }.padding(.vertical, 20)
                        .padding(.horizontal, 16)
                }
            }
        }.ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.mainWhite)
    }
}
