//
//  AccountSummeryView.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 06.11.2024.
//

import SwiftUI
import Kingfisher

struct AccountSummaryView: View {
    let profileImage: String?
    var hasProfileImage: Bool = true
    let name: String
    let action: () -> ()
    
    var body: some View {
        HStack(spacing: 12) {
            if hasProfileImage {
                Button {
                    action()
                } label: {
                    KFImage(URL(string: profileImage ?? ""))
                        .resizable()
                        .placeholder {
                            Image(.icCamera)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(Color.mainBlack)
                                .frame(width: 24, height: 24)
                                .padding(.all, 28)
                                .background(Circle().fill(Color.mainGray))
                        }
                        .centerCropped()
                        .clipShape(Circle())
                        .frame(width: 84, height: 84)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.poppinsBold(size: 28))
                    .foregroundStyle(Color.mainBlack)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
    }
}
