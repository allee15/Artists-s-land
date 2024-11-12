//
//  SideButtonView.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import SwiftUI

struct SideButtonView: View {
    let icon: ImageResource
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(icon)
                .resizable()
                .renderingMode(.template)
                .frame(width: 32, height: 32)
                .foregroundStyle(Color.mainBlack)
        }
    }
}

struct LeftRightNavBarView: View {
    let chat: Chat
    let action: () -> ()
    var body: some View {
        HStack(spacing: 12) {
            BackButton()
            ChatPicPlaceHolder(name: chat.name, avatarUrl: chat.artistAvatarUrl)
            Spacer()
            SideButtonView(icon: .icNavbarDelete) {
                action()
            }
        }
    }
}
