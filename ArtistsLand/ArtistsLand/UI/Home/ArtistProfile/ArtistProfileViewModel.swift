//
//  ArtistProfileViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 11.11.2024.
//

import Foundation
import Combine

enum ArtistPostsState {
    case loading
    case failure(Error)
    case value([Post])
}

enum ArtistInfoState {
    case loading
    case failure(Error)
    case value(User)
}

enum ChatCreationCompletion {
    case created
    case failed
    case notLoggedIn
    case reportSent
}

class ArtistProfileViewModel: BaseViewModel {
    var userService = UserService.shared
    var postsService = PostsService.shared
    var chatService = ChatService.shared
    
    var artistId: String
    @Published var artistInfoState = ArtistInfoState.loading
    @Published var user: User?
    @Published var artistPostState = ArtistPostsState.loading
    let eventSubject = PassthroughSubject<ChatCreationCompletion, Never>()
    
    init(artistId: String) {
        self.artistId = artistId
        super.init()
        getArtistInfo()
        getUserInfo()
        getArtistPosts() 
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
    
    func getArtistPosts() {
        postsService.getArtistPosts(artistId: artistId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    self.artistPostState = .failure(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] posts in
                guard let self = self else { return }
                self.artistPostState = .value(posts)
            }).store(in: &bag)
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
    
    func addCommentToPost(comment: String, postId: String, artistName: String) {
        guard case .value(var posts) = artistPostState else { return }
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            let newComment = Comment(id: UUID().uuidString, name: artistName, description: comment)
            posts[index].comments.append(newComment)
            artistPostState = .value(posts)
            
            postsService.addCommentToPost(comment: comment, postId: postId)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] success in
                    guard let self else { return }
                    if !success {
                        posts[index].comments.removeAll { $0.id == newComment.id }
                        self.artistPostState = .value(posts)
                    }
                }).store(in: &bag)
        }
    }

    func likePost(postId: String) {
        guard case .value(var posts) = artistPostState else { return }
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].nbOfLikes += 1
            artistPostState = .value(posts)
            
            postsService.likePost(postId: postId)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] success in
                    guard let self else { return }
                    if !success {
                        posts[index].nbOfLikes -= 1
                        self.artistPostState = .value(posts)
                    }
                }).store(in: &bag)
        }
    }
    
    func unlikePost(postId: String) {
        guard case .value(var posts) = artistPostState else { return }
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].nbOfLikes -= 1
            artistPostState = .value(posts)
            
            postsService.unlikePost(postId: postId)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] success in
                    guard let self else { return }
                    if !success {
                        posts[index].nbOfLikes += 1
                        self.artistPostState = .value(posts)
                    }
                }).store(in: &bag)
        }
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
    
    func reportPost(postId: String) {
        postsService.reportPost(postId: postId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] success in
                guard let self else { return }
                self.eventSubject.send(.reportSent)
            }).store(in: &bag)
    }
}
