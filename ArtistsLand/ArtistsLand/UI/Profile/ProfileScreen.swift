//
//  ProfileScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import SwiftUI

struct ProfileScreen: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        Text("Profile screen")
    }
}

