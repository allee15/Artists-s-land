//
//  HomeViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import Foundation

enum PostsState {
    case loading
    case failure(Error)
    case value([Post])
}

class HomeViewModel: BaseViewModel {
    var postsService = PostsService.shared
    var userService = UserService.shared
    
    @Published var isLoading: Bool = false
    @Published var user: User?
    @Published var postsState = PostsState.loading
    
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
//        postsService.getPosts()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.postsState = .value(postsMocked)
        }
    }
    
    func likePost(postId: String) {
        postsService.likePost(postId: postId)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] result in
                guard let self else {return}
                if result {
                    //TODO
                } else {
                    //TODO
                }
            }.store(in: &bag)
    }
    
    func unlikePost(postId: String) {
        postsService.unlikePost(postId: postId)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] result in
                guard let self else {return}
                if result {
                    //TODO
                } else {
                    //TODO
                }
            }.store(in: &bag)
    }
    
    func addCommentToPost(comment: String, postId: String) {
        postsService.addCommentToPost(comment: comment, postId: postId)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] result in
                guard let self else {return}
                if result {
                    //TODO
                } else {
                    //TODO
                }
            }.store(in: &bag)
    }
    
    func reportPost(postId: String) {
        postsService.reportPost(postId: postId)
    }
}
