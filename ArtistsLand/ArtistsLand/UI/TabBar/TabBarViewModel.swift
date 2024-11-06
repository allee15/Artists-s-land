//
//  TabBarViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import Foundation
import Combine

class TabBarViewModel: ObservableObject {
    @Published var selectedTabItem: TabBarItemType
    @Published var tabBarItems: [TabBarItem]
    
    public var oldSelectedTab: TabBarItemType
    
    init() {
        self.selectedTabItem = .home
        self.oldSelectedTab = .home
        
        tabBarItems = [
            homeTabBarItem,
            searchTabBarItem,
            chatsTabBarItem,
            profileNewsTabBarItem
        ]
    }
}

