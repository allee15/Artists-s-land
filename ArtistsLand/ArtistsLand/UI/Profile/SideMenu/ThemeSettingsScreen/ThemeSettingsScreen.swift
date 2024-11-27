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
        VStack(spacing: 0) {
            LeftNavBarView(title: "App settings") {
                navigation.pop(animated: true)
            }
            
            ScrollView(showsIndicators: false) {
                HStack(spacing: 20) {
                    ThemeWidgetView(image: .icLightTheme,
                                    title: "Light",
                                    isSelected: $viewModel.isLightModeSelected) {
                        viewModel.applyThemeBasedOnPreference(theme: .light)
                    }
                    
                    ThemeWidgetView(image: .icDarkTheme, 
                                    title: "Dark",
                                    isSelected: $viewModel.isDarkModeSelected) {
                        viewModel.applyThemeBasedOnPreference(theme: .dark)
                    }
                    
                    ThemeWidgetView(image: .icSystemTheme,
                                    title: "System",
                                    isSelected: $viewModel.isSystemModeSelected) {
                        viewModel.applyThemeBasedOnPreference(theme: .system)
                    }
                }.padding(.horizontal, 16)
                    .padding(.top, 32)
            }
        }.background(Color.mainWhite)
            .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

fileprivate struct ThemeWidgetView: View {
    let image: ImageResource
    let title: String
    @Binding var isSelected: Bool?
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                VStack(spacing: 16) {
                    Image(image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.secondaryBlueInversat)
                        .frame(width: 50, height: 50)
                    
                    Text(title)
                        .font(.poppinsRegular(size: 14))
                        .foregroundStyle(Color.mainBlack)
                    
                    if let isSelected = isSelected {
                        Image(isSelected ? .icOn : .icOff)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.secondaryBlueInversat)
                            .frame(width: 25, height: 25)
                    }
                }
                Spacer()
            }.padding(.vertical, 20)
                .background(Color.mainGray)
                .cornerRadius(4, corners: .allCorners)
        }
    }
}
