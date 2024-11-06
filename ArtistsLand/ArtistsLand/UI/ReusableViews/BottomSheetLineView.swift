//
//  BottomSheetLineView.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 06.11.2024.
//

import SwiftUI

struct BottomSheetLineView: View {
    var body: some View {
        Rectangle()
            .fill(Color.bottomSheetLine)
            .frame(width: 36, height: 6)
            .cornerRadius(72, corners: .allCorners)
    }
}
