//
//  NavBarView.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import SwiftUI

struct NavBarView: View {
    var isCloseButton: Bool = false
    
    var body: some View {
        HStack {
            if isCloseButton {
                CloseButton()
            } else {
                BackButton()
            }
            Spacer()
        }.padding(.horizontal, 12)
    }
}
