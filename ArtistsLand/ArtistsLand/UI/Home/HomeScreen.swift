//
//  HomeScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        Text("Home screen")
    }
}
