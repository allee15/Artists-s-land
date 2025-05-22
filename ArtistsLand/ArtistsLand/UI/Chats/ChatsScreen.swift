//
//  ChatsScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import SwiftUI

struct ChatsScreen: View {
    @StateObject var viewModel = ChatsViewModel()
    private let mainNavigation = EnvironmentObjects.navigation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LeftNavBarView(title: "Chats", hasBackButton: false) {}
            
            if let user = viewModel.user {
                switch viewModel.chatsState {
                case .failure(_):
                    VStack {
                        Spacer()
                        Text("An error has occured. Please try again!")
                            .font(.poppinsSemiBold(size: 20))
                            .foregroundStyle(Color.mainBlack)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 12)
                        
                        ClearButton(text: "Try again") {
                            viewModel.getChats()
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
                case .value(let chats):
                    if chats.isEmpty {
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                Text("No chats available. Start a new one!")
                                    .foregroundColor(Color.pink3Custom)
                                    .font(.poppinsRegular(size: 16))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                                Spacer()
                            }
                            Spacer()
                        }
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 16) {
                                ForEach(chats, id: \.conversationId) { chat in
                                    Button {
                                        let vm = ConversationViewModel(user: user, chat: chat)
                                        mainNavigation?.push(ConversationScreen(viewModel: vm).asDestination(),
                                                             animated: true)
                                    } label: {
                                        ChatCardView(chat: chat)
                                    }
                                }
                            }
                        }.padding(.vertical, 20)
                    }
                }
            } else {
                UnloggedUserView()
            }
        }.background(Color.mainWhite)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                if TabBarCoordinator.instance.shouldGetChats {
                    viewModel.getChats()
                }
            }
    }
}

fileprivate struct ChatCardView: View {
    let chat: Chat
    
    var body: some View {
        HStack {
            ChatPicPlaceHolder(name: chat.secondParticipantName, fontSize: 18,
                               avatarUrl: chat.secondParticipantAvatar, width: 44)
            
            Spacer()
            
            HStack(spacing: 4) {
                Text(chat.lastMessage ?? "")
                    .font(.poppinsBold(size: 12))
                    .foregroundStyle(Color.black)
                
                Text(chat.lastMessageTime ?? "")
                    .font(.poppinsRegular(size: 12))
                    .foregroundStyle(Color.white)
            }
            
            Spacer()
            
            Image(.icItemresultArrow)
                .resizable()
                .renderingMode(.template)
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.black)
            
        }.padding(.all, 16)
            .background(Color.lightPinkCustom)
            .border(Color.lightPinkCustom, width: 2, cornerRadius: 8)
            .padding(.horizontal, 16)
    }
}
