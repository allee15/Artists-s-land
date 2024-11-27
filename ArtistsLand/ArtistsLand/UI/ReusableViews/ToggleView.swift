//
//  ToggleView.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 06.11.2024.
//

import SwiftUI

struct ToggleView: View {
    @Binding var isOn: Bool
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Toggle(isOn: $isOn) { }
                .toggleStyle(.switch)
                .labelsHidden()
                .tint(Color.secondaryBlueInversat)
                .frame(width: 64, height: 32)
        }
    }
}
