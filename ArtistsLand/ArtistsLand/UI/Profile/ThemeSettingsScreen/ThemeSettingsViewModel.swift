//
//  ThemeSettingsViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import Foundation
import UIKit

enum SchemeType: String, CaseIterable {
    case light
    case dark
    case system
}

class ThemeSettingsViewModel: BaseViewModel {
    var userDefaultsService = UserDefaultsService.shared
    
    @Published var isLightModeSelected: Bool?
    @Published var isDarkModeSelected: Bool?
    @Published var isSystemModeSelected: Bool?
    
    override init() {
        super.init()
        loadThemePreference()
    }
    
    func loadThemePreference() {
        let key: Key<String> = Key(value: UserDefaultsKeys.appTheme)
        let storedTheme = userDefaultsService.getValue(key: key)
        
        self.isLightModeSelected = storedTheme == "light"
        self.isDarkModeSelected = storedTheme == "dark"
        self.isSystemModeSelected = storedTheme == "system"
        
        if let storedTheme = storedTheme, let themeType = SchemeType(rawValue: storedTheme) {
            applyThemeBasedOnPreference(theme: themeType)
        } else {
            applyThemeBasedOnPreference(theme: .system)
        }
    }
    
    func applyThemeBasedOnPreference(theme: SchemeType) {
        let key: Key<String> = Key(value: UserDefaultsKeys.appTheme)
        
        switch theme {
        case .light:
            userDefaultsService.setValue(key: key, value: "light")
            self.isLightModeSelected = true
            self.isDarkModeSelected = false
            self.isSystemModeSelected = false
            applyUserInterfaceStyle(.light)
        case .dark:
            userDefaultsService.setValue(key: key, value: "dark")
            self.isLightModeSelected = false
            self.isDarkModeSelected = true
            self.isSystemModeSelected = false
            applyUserInterfaceStyle(.dark)
        case .system:
            userDefaultsService.setValue(key: key, value: "system")
            self.isLightModeSelected = false
            self.isDarkModeSelected = false
            self.isSystemModeSelected = true
            applyUserInterfaceStyle(.unspecified)
        }
    }
    
    private func applyUserInterfaceStyle(_ style: UIUserInterfaceStyle) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = style
            }
        }
    }
}
