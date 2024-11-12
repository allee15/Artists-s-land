//
//  BackButton.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import SwiftUI

struct BackButton: View {
    @EnvironmentObject private var navigation: Navigation
    var imageColor: Color = .mainBlack
    var action: (()->())?
    
    var body: some View {
        Button {
            if let action = action {
                action()
            } else {
                navigation.pop(animated: true)
            }
        } label: {
            Image(.icNavUp)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(imageColor)
                .frame(width: 32, height: 32)
        }
    }
}
