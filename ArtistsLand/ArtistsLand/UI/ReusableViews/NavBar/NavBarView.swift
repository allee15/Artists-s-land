//
//  NavBarView.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import SwiftUI

struct NavBarView: View {
    @EnvironmentObject private var navigation: Navigation
    
    var isCloseButton: Bool = false
    
    var body: some View {
        HStack {
            if isCloseButton {
                CloseButton() {
                    navigation.replaceNavigationStack([TabBarScreen().asDestination()], animated: true)
                }
            } else {
                BackButton()
            }
            Spacer()
        }.padding(.horizontal, 12)
    }
}
