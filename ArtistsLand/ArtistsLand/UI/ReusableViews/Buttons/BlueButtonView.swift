//
//  BlueButtonView.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import SwiftUI

struct BlueButtonView: View {
    let text: String
    var isDisabled: Bool = false
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.poppinsSemiBold(size: 14))
                .padding(.all, 12)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(Color.pink3Custom)
                .cornerRadius(4, corners: .allCorners)
        }.disabled(isDisabled)
    }
}
