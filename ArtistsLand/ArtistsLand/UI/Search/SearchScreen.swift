//
//  SearchScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import SwiftUI

struct SearchScreen: View {
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        Text("Search screen")
    }
}
