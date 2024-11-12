//
//  ArtistProfileViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 11.11.2024.
//

import Foundation

enum ArtistInfoState {
    case loading
    case failure(Error)
    case value(User)
}


class ArtistProfileViewModel: BaseViewModel {
    var userService = UserService.shared
    var artistId: Int64
    @Published var artistInfoState = ArtistInfoState.loading
    
    init(artistId: Int64) {
        self.artistId = artistId
    }
    
    func getArtistInfo() {
//        userService.getArtistInfo(artistId: artistId)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.artistInfoState = .value(userMocked)
        }
    }
}
