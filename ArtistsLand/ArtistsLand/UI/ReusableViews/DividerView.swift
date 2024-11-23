//
//  DividerView.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 12.11.2024.
//

import SwiftUI

struct DividerView: View {
    var body: some View {
        Rectangle()
            .foregroundStyle(Color.mainBlue)
            .frame(height: 1)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    DividerView()
}
