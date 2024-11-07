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
        if true {//viewModel.user != nil {
            VStack(alignment: .leading, spacing: 0) {
                Text("Your chats")
                    .font(.poppinsBold(size: 24))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                
                Color.mainBlueInversat.frame(height: 1)
                    .padding(.top, 12)
                
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
                                    mainNavigation?.push(ConversationScreen().asDestination(),
                                                         animated: true)
                                } label: {
                                    ChatCardView(name: chat.name)
                                }
                            }
                        }
                    }.padding(.vertical, 20)
                }
            }.background(Color.mainWhite)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            UnloggedUserView()
        }
    }
}

fileprivate struct ChatCardView: View {
    let name: String
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .font(.poppinsSemiBold(size: 16))
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
            }
            
            Spacer()
            
            Image(.icItemresultArrow)
                .resizable()
                .renderingMode(.template)
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.mainBlack)
            
        }.padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.white)
        .padding(.horizontal, 16)
    }
}
