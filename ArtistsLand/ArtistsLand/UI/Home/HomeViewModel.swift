//
//  HomeViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import Foundation
import Combine

enum PostsState {
    case loading
    case failure(Error)
    case value([Post])
}

enum ReportCompletion {
    case sent
}

class HomeViewModel: BaseViewModel {
    var postsService = PostsService.shared
    var userService = UserService.shared
    
    @Published var isLoading: Bool = false
    @Published var user: User?
    @Published var postsState = PostsState.loading
    let eventSubject = PassthroughSubject<ReportCompletion, Never>()
    
    override init() {
        super.init()
        self.loadPosts()
        self.getUserInfo()
    }
    
    private func getUserInfo() {
        userService.userReactiveData.getStateSubject()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] userState in
                guard let self = self else { return }
                switch userState {
                case .failure(_):
                    self.isLoading = false
                case .loading:
                    self.isLoading = true
                case .ready(let userState):
                    self.isLoading = false
                    switch userState {
                    case .anonymous:
                        self.user = nil
                    case .loggedIn(let user):
                        self.user = user
                    }
                }
            }).store(in: &bag)
    }
    
    func loadPosts() {
        postsService.getPosts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    self.postsState = .failure(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] posts in
                guard let self = self else { return }
                self.postsState = .value(posts)
            }).store(in: &bag)
    }
    
    func likePost(postId: String) {
        guard case .value(var posts) = postsState else { return }
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].nbOfLikes += 1
            postsState = .value(posts)
            
            postsService.likePost(postId: postId)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] success in
                    guard let self else { return }
                    if !success {
                        posts[index].nbOfLikes -= 1
                        self.postsState = .value(posts)
                    }
                }).store(in: &bag)
        }
    }
    
    func unlikePost(postId: String) {
        guard case .value(var posts) = postsState else { return }
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].nbOfLikes -= 1
            postsState = .value(posts)
            
            postsService.unlikePost(postId: postId)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] success in
                    guard let self else { return }
                    if !success {
                        posts[index].nbOfLikes += 1
                        self.postsState = .value(posts)
                    }
                }).store(in: &bag)
        }
    }
    
    func addCommentToPost(comment: String, postId: String) {
        guard case .value(var posts) = postsState else { return }
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            let newComment = Comment(id: UUID().uuidString, name: user?.nickname ?? "Anonymous", description: comment)
            posts[index].comments.append(newComment)
            postsState = .value(posts)
            
            postsService.addCommentToPost(comment: comment, postId: postId)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] success in
                    guard let self else { return }
                    if !success {
                        posts[index].comments.removeAll { $0.id == newComment.id }
                        self.postsState = .value(posts)
                    }
                }).store(in: &bag)
        }
    }
    
    func reportPost(postId: String) {
        postsService.reportPost(postId: postId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] success in
                guard let self else { return }
                self.eventSubject.send(.sent)
            }).store(in: &bag)
    }
}
