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
    
    @Published var user: User?
    @Published var postsState = PostsState.loading
    
    override init() {
        super.init()
        self.loadPosts()
        self.getUserInfo()
    }
    
    private func getUserInfo() {
        userService.userReactiveData.getStateSubject()
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] userState in
                guard let self = self else { return }
                self.user = userMocked
//                switch userState {
//                case .failure(_):
//                    self.isLoading = false
//                case .loading:
//                    self.isLoading = true
//                case .ready(let userState):
//                    self.isLoading = false
//                    switch userState {
//                    case .anonymous:
//                        self.userInfo = nil
//                    case .loggedIn(let user):
//                        self.userInfo = user
//                    }
//                }
            }).store(in: &bag)
    }
    
    func loadPosts() {
//        postsService.getPosts()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.postsState = .value(postsMocked)
        }
    }
    
    func likePost(postId: Int64) {
        postsService.likePost(postId: postId)
    }
    
    func addCommentToPost(comment: String, postId: Int64) {
        let commentToSend = Comment(id: 3, name: user?.nickname ?? "", description: comment)
        postsService.addCommentToPost(comment: commentToSend, postId: postId)
    }
    
    func deletePost(postId: Int64) {
        postsService.deletePost(postId: postId)
    }
    
    func reportPost(postId: Int64) {
        postsService.reportPost(postId: postId)
    }
}
