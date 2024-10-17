//
//  RegisterScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import SwiftUI

struct RegisterScreen: View {
    @EnvironmentObject private var navigation: Navigation
    @StateObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        Text("Register")
            .onTapGesture {
                navigation.replaceNavigationStack([TabBarScreen().asDestination()], animated: true)
            }
    }
}
