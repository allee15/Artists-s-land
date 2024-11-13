//
//  ProfileViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import Foundation
import UIKit
import Combine

class ProfileViewModel: BaseViewModel {
    var userService = UserService.shared
    var postsService = PostsService.shared
    
    @Published var userInfo: User?
    @Published var profileImage: UIImage?
    @Published var newPostImage: UIImage?
    @Published var isLoading: Bool = false
    let eventSubject = PassthroughSubject<EditAccountCompletion, Never>()
    let eventSubjectForImages = PassthroughSubject<SendImageCompletion, Never>()
    
    override init() {
        super.init()
        getUserInfo()
    }
    
    private func getUserInfo() {
        userService.userReactiveData.getStateSubject()
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] userState in
                guard let self = self else { return }
                self.userInfo = userMocked
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
    
    func updateProfileImage(id: Int, shouldDeleteAvatar: Bool? = nil) {
        userService.updateProfileImage(id: id, shouldDeleteAvatar: shouldDeleteAvatar)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] response in
                guard let self else {return}
                if response {
                    
                    self.eventSubject.send(.completed)
                } else {
                    self.eventSubject.send(.error)
                }
            }).store(in: &bag)
    }
    
    func addCommentToPost(comment: String, postId: Int64) {
        let commentToSend = Comment(id: 3, name: userMocked.nickname, description: comment)
        postsService.addCommentToPost(comment: commentToSend, postId: postId)
    }
    
    func likePost(postId: Int64) {
        postsService.likePost(postId: postId)
    }
    
    func postImage() {
        postsService.postImage()
        self.eventSubjectForImages.send(.sent)
    }
}
