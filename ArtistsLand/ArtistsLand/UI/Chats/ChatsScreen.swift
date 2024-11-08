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
                if viewModel.userChats.isEmpty {
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Text("No chats available. Start a new one!")
                                .foregroundColor(Color.mainBlueInversat)
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
                            ForEach(viewModel.userChats, id: \.name) { chat in
                                Button {
                                    let vm = ConversationViewModel(user: user)
                                    mainNavigation?.push(ConversationScreen(viewModel: vm).asDestination(),
                                                         animated: true)
                                } label: {
                                    ChatCardView(name: chat.name)
                                }
                            }
                        }
                    }.padding(.vertical, 20)
                }
            } else {
                UnloggedUserView()
            }
        }.background(Color.mainWhite)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

fileprivate struct ChatCardView: View {
    let name: String
    
    var body: some View {
        HStack {
            Text(name)
                .font(.poppinsSemiBold(size: 16))
                .foregroundColor(Color.mainBlack)
            
            Spacer()
            
            Image(.icItemresultArrow)
                .resizable()
                .renderingMode(.template)
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.mainBlack)
            
        }.padding(.all, 16)
            .background(Color.mainBlue.opacity(0.5))
            .border(Color.mainBlue.opacity(0.5), width: 2, cornerRadius: 8)
            .padding(.horizontal, 16)
    }
}
