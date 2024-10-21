//
//  WalletScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 22.10.2024.
//

import SwiftUI

struct WalletScreen: View {
    @StateObject private var viewModel = WalletViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        Text("Wallet screen")
    }
}

#Preview {
    WalletScreen()
}
