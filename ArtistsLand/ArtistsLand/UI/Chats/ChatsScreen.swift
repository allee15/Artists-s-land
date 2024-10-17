//
//  ChatsScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import SwiftUI

struct ChatsScreen: View {
    @StateObject private var viewModel = ChatsViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        Text("Chats screen")
    }
}
