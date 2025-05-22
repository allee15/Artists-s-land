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
                    let localPath = profileImage ?? ""
                    KFImage(URL(string: "file://\(localPath)"))
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
                        .frame(width: 60, height: 60)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.poppinsBold(size: 20))
                    .foregroundStyle(Color.mainBlack)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
    }
}
