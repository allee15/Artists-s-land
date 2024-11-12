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
    let action: (Bool) -> ()
    let commentsAction: (String) -> ()
    let nameAction: (Int64) -> ()
    @State private var isLiked: Bool = false
    @State private var showComments: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 12) {
                Button {
                    nameAction(post.artistId)
                } label: {
                    ChatPicPlaceHolder(name: post.artistName, avatarUrl: post.artistAvatarUrl)
                }
                
                Button {
                    mainNavigation?.push(ZoomImageScreen(imageToZoom: post.postUrl).asDestination(), animated: true)
                } label: {
                    KFImage(URL(string: post.postUrl))
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
