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
    case notLoggedIn
}

class ArtistProfileViewModel: BaseViewModel {
    var userService = UserService.shared
    var postsService = PostsService.shared
    var chatService = ChatService.shared
    
    var artistId: String
    @Published var artistInfoState = ArtistInfoState.loading
    @Published var user: User?
    let eventSubject = PassthroughSubject<ChatCreationCompletion, Never>()
    
    init(artistId: String) {
        self.artistId = artistId
        super.init()
        getArtistInfo()
        getUserInfo()
    }
    
    func getArtistInfo() {
        userService.getArtistInfo(artistId: artistId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    self.artistInfoState = .failure(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] chats in
                guard let self else {return}
                self.artistInfoState = .value(chats)
            }.store(in: &bag)

    }
    
    private func getUserInfo() {
        userService.userReactiveData.getStateSubject()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] userState in
                guard let self = self else { return }
                switch userState {
                case .failure(_):
                    break
                case .loading:
                    break
                case .ready(let userState):
                    switch userState {
                    case .anonymous:
                        self.user = nil
                    case .loggedIn(let user):
                        self.user = user
                    }
                }
            }).store(in: &bag)
    }
    
    func likePost(postId: Int64) {
        postsService.likePost(postId: postId)
    }
    
    func addCommentToPost(comment: String, postId: Int64) {
        let commentToSend = Comment(id: 3, name: userMocked.nickname, description: comment)
        postsService.addCommentToPost(comment: commentToSend, postId: postId)
    }
    
    func createChat() {
        let messageToSend = Message(senderId: user?.id ?? "",
                                    receiverId: artistId,
                                    message: "Hi",
                                    fileUrl: nil,
                                    createdAt: "")
        chatService.sendMessage(message: messageToSend)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] result in
                guard let self else {return}
                if !result.senderId.isEmpty {
                    self.eventSubject.send(.created)
                }
            }.store(in: &bag)
    }
    
    func deletePost(postId: Int64) {
        postsService.deletePost(postId: postId)
    }
    
    func reportPost(postId: Int64) {
        postsService.reportPost(postId: postId)
    }
}
