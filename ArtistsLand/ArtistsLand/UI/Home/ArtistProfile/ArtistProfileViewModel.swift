//
//  ArtistProfileViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 11.11.2024.
//

import Foundation
import Combine

enum ArtistInfoState {
    case loading
    case failure(Error)
    case value(User)
}

enum ChatCreationCompletion {
    case created
    case failed
}

class ArtistProfileViewModel: BaseViewModel {
    var userService = UserService.shared
    var postsService = PostsService.shared
    var chatService = ChatService.shared
    
    var artistId: Int64
    @Published var artistInfoState = ArtistInfoState.loading
    let eventSubject = PassthroughSubject<ChatCreationCompletion, Never>()
    
    init(artistId: Int64) {
        self.artistId = artistId
        super.init()
        getArtistInfo()
    }
    
    func getArtistInfo() {
//        userService.getArtistInfo(artistId: artistId)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.artistInfoState = .value(userMocked)
        }
    }
    
    func likePost(postId: Int64) {
        postsService.likePost(postId: postId)
    }
    
    func addCommentToPost(comment: String, postId: Int64) {
        let commentToSend = Comment(id: 3, name: userMocked.nickname, description: comment)
        postsService.addCommentToPost(comment: commentToSend, postId: postId)
    }
    
    func createChat(artistId: Int) {
//        chatService.createChat(artistId: artistId)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.eventSubject.send(.created)
        }
    }
    
    func deletePost(postId: Int64) {
        postsService.deletePost(postId: postId)
    }
    
    func reportPost(postId: Int64) {
        postsService.reportPost(postId: postId)
    }
}
