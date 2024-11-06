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
