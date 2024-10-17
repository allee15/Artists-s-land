//
//  ThemeSettingsScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import SwiftUI

struct ThemeSettingsScreen: View {
    @StateObject private var viewModel = ThemeSettingsViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        Text("Theme")
            .onTapGesture {
                navigation.pop(animated: true)
            }
        
        HStack {
            Button {
                viewModel.applyThemeBasedOnPreference(theme: .light)
            } label: {
                Text("Light")
            }
            
            Button {
                viewModel.applyThemeBasedOnPreference(theme: .dark)
            } label: {
                Text("Dark")
            }
            
            Button {
                viewModel.applyThemeBasedOnPreference(theme: .system)
            } label: {
                Text("System")
            }
        }
    }
}

#Preview {
    ThemeSettingsScreen()
}
