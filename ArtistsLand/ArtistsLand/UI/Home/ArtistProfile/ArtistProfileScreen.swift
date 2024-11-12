//
//  ArtistProfileScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 11.11.2024.
//

import SwiftUI

struct ArtistProfileScreen: View {
    @StateObject var viewModel: ArtistProfileViewModel
    var body: some View {
        VStack(spacing: 0) {
            TitleNavBarView(title: "Artists land")
            
            switch viewModel.artistInfoState {
            case .loading:
                VStack {
                    Spacer()
                    LoaderView()
                    Spacer()
                }
            case .failure:
                VStack {
                    Spacer()
                    Text("An error has occured. Please try again!")
                        .font(.poppinsSemiBold(size: 20))
                        .foregroundStyle(Color.mainBlack)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 12)
                    
                    ClearButton(text: "Try again") {
                        viewModel.getArtistInfo()
                    }
                    Spacer()
                }
            case .value(let artistInfo):
                EmptyView()
            }
        }
    }
}
