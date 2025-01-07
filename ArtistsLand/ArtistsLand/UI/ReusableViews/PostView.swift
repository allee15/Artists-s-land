//
//  PostView.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 11.11.2024.
//

import SwiftUI
import Kingfisher

struct PostView: View {
    private let mainNavigation = EnvironmentObjects.navigation
    
    let post: Post
    var showName: Bool = true
    var canDeletePost: Bool = false
    let action: (Bool) -> ()
    let commentsAction: (String) -> ()
    let nameAction: (String) -> ()
    let deleteAction: (Bool, Post) -> ()
    @State private var isLiked: Bool = false
    @State private var showComments: Bool = false
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    if showName {
                        Button {
                            nameAction(post.artistId)
                        } label: {
                            ChatPicPlaceHolder(name: post.artistName, avatarUrl: post.artistAvatarUrl)
                        }
                    }
                    Spacer()
                    Button {
                        let modal = ModalChooseOptionView(title: "Manage post",
                                                          description: canDeletePost ? "As an author of this post, you can delete it." : "You can report this post if you consider that it voilates our terms.",
                                                          topButtonText: canDeletePost ? "Delete post" : "Report",
                                                          bottomButtonText: "Close") {
                            deleteAction(canDeletePost, post)
                            navigation.dismissModal(animated: true, completion: nil)
                        } onBottomButtonTapped: {
                            navigation.dismissModal(animated: true, completion: nil)
                        }
                        
                        navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                    } label: {
                        Image(.icReport)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.mainBlack)
                    }
                }
                
                Button {
                    mainNavigation?.push(ZoomImageScreen(imageToZoom: post.postUrl).asDestination(), animated: true)
                } label: {
                    let localPath = post.postUrl
                    KFImage(URL(string: "file://\(localPath)"))
                        .resizable()
                        .placeholder {
                            Image(.imgPlaceholder)
                                .resizable()
                        }
                        .centerCropped()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 4)
                }
                
                Text(post.description)
                    .font(.poppinsRegular(size: 16))
                    .foregroundStyle(Color.mainBlueInversat)
                    .multilineTextAlignment(.leading)
            }
            
            HStack(spacing: 8) {
                Button {
                    isLiked.toggle()
                    action(isLiked)
                } label: {
                    Image(isLiked ? .icFavorite : .icNotFavorite)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.simpleBlue)
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                
                Text("\(post.nbOfLikes)")
                    .foregroundStyle(Color.simpleBlue)
                    .font(.poppinsSemiBold(size: 16))
                
                Spacer()
                
                Button {
                    self.showComments = true
                } label: {
                    Image(.icComments)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.simpleBlue)
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            }.padding(.bottom, 8)
            
            DividerView()
        }.sheet(isPresented: $showComments) {
            CommentsView(comments: post.comments) { comment in
                commentsAction(comment)
            }
        }
    }
}

struct CommentsView: View {
    @State private var message: String = ""
    let comments: [Comment]
    let action: (String) -> ()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                BottomSheetLineView()
                Spacer()
            }.padding(.horizontal, 16)
            
            Text("Comments section")
                .foregroundStyle(Color.mainBlack)
                .font(.poppinsSemiBold(size: 16))
                .padding([.horizontal, .top], 16)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(comments, id: \.id) { comment in
                        SingleCommentView(comment: comment)
                    }
                }.padding([.horizontal, .top], 16)
            }
            
            Rectangle()
                .frame(height: 1)
                .padding(.horizontal, 2)
                .foregroundColor(Color.contentSecondary)
            
            SendMessageField(text: $message,
                             placeHolder: "Type your message",
                             icon: .icSend,
                             iconSecond: .icAddPhoto) {
                action(message)
            }
        }.padding(.top, 20)
        .background(Color.mainWhite)
    }
}

struct SingleCommentView: View {
    let comment: Comment
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(comment.name)
                    .font(.poppinsSemiBold(size: 12))
                    .foregroundStyle(Color.simpleBlue)
                
                Text(comment.description)
                    .font(.poppinsRegular(size: 14))
                    .foregroundStyle(Color.mainBlack)
            }.padding(.all, 12)
                .background(Color.simpleBlue.opacity(0.3))
                .cornerRadius(4, corners: .allCorners)
            Spacer()
        }
    }
}
