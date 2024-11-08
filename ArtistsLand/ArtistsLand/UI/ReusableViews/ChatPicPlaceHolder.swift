//
//  ChatPicPlach.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 08.11.2024.
//

import SwiftUI

struct ChatPicPlaceHolder: View {
    let name: String
    var fontSize: CGFloat = 12
    var width: CGFloat = 36
    
    var body: some View {
        HStack(spacing: 12) {
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
                    .foregroundColor(.black)
            }
            
            Text(name)
                .font(.poppinsSemiBold(size: fontSize))
                .foregroundColor(.black)
        }
    }
}
