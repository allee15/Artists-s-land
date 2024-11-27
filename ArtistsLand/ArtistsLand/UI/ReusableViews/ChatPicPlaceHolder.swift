//
//  ChatPicPlach.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 08.11.2024.
//

import SwiftUI
import Kingfisher

struct ChatPicPlaceHolder: View {
    let name: String
    var fontSize: CGFloat = 16
    var avatarUrl: String?
    var width: CGFloat = 36
    
    var body: some View {
        HStack(spacing: 12) {
            if let avatarUrl = avatarUrl {
//                let localPath = avatarUrl
//                KFImage(URL(string: "file://\(localPath)"))
                KFImage(URL(string: avatarUrl))
                    .resizable()
                    .placeholder {
                        Circle()
                            .fill(Color.white)
                            .frame(width: width, height: width)
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    .centerCropped()
                    .cornerRadius(28, corners: .allCorners)
                    .frame(width: width, height: width)
            } else {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: width, height: width)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 2)
                        )
                    Text(name.first?.uppercased() ?? "A")
                        .font(.poppinsSemiBold(size: fontSize))
                        .foregroundColor(Color.black)
                }
            }
            
            Text(name)
                .font(.poppinsSemiBold(size: fontSize))
                .foregroundColor(Color.mainBlack)
        }
    }
}
