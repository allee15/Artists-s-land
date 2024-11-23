//
//  LeftNavBar.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import SwiftUI

struct LeftNavBarView: View {
    let title: String
    var isCloseButton: Bool = false
    var hasBackButton: Bool = true
    let backAction: () -> ()
    
    var body: some View {
        HStack {
            BackButton {
                backAction()
            }.opacity(hasBackButton ? 1 : 0)
            
            Spacer()
            
            TitleNavBarView(title: title)
            
            Spacer()
            
            BackButton {
                backAction()
            }.opacity(0)
        }.padding([.horizontal, .bottom], 16)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color.mainWhite)
            .shadow(color: Color.mainBlack.opacity(0.3), radius: 1, x: 0, y: 0)
            .zIndex(1)
    }
}
