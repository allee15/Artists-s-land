//
//  TitleNavBarView.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import SwiftUI

struct TitleNavBarView: View {
    let title: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .foregroundColor(.mainBlack)
                .font(.poppinsBold(size: 20))
                
            Spacer()
        }
    }
}
