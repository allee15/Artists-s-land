//
//  RightNavBar.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import SwiftUI

struct RightNavBarView: View {
    let icon: ImageResource
    let title: String
    let action: () -> ()
    
    var body: some View {
        HStack {
            SideButtonView(icon: icon) {}.opacity(0)
            
            Spacer()
            
            TitleNavBarView(title: title)
            
            Spacer()
            
            SideButtonView(icon: icon) {
                action()
            }
        }.padding([.horizontal, .bottom], 16)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color.mainWhite)
            .shadow(color: Color.mainBlack.opacity(0.3), radius: 1, x: 0, y: 0)
            .zIndex(1)
    }
}
