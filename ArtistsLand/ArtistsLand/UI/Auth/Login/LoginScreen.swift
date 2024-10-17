//
//  LoginScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject private var navigation: Navigation
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        Text("Login")
            .onTapGesture {
                navigation.push(RegisterScreen().asDestination(), animated: true)
            }
    }
}
