//
//  MainBlueButtonView.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import SwiftUI

struct MainBlueButtonView: View {
    let text: String
    var isDisabled: Bool = false
    var icon: ImageResource?
    var action: () -> ()
    var body: some View {
        Button {
            action()
        } label: {
            HStack (spacing: 8) {
                Text(text)
                    
                if let icon = icon {
                    Image(icon)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }.font(.poppinsSemiBold(size: 14))
                .padding(.all, 12)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(isDisabled ? Color.mainBlueButton.opacity(0.5) : Color.mainBlueButton)
                .cornerRadius(4, corners: .allCorners)
        }.disabled(isDisabled)
    }
}
