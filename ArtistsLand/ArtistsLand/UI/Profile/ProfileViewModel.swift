//
//  ProfileViewModel.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import Foundation
import UIKit
import Combine

enum UserPostsState {
    case loading
    case failure(Error)
    case value([Post])
}

enum SendImageCompletion {
    case sent
    case failed
}

class ProfileViewModel: BaseViewModel {
    var userService = UserService.shared
    var postsService = PostsService.shared
    
    @Published var userInfo: User?
    @Published var userPostState = UserPostsState.loading
    @Published var profileImage: UIImage?
    @Published var newPostImage: UIImage?
    @Published var isLoading: Bool = false
    @Published var newPostDescription: String = ""
    @Published var errorPostDescription: String?
    
    let eventSubject = PassthroughSubject<EditAccountCompletion, Never>()
    let eventSubjectForImages = PassthroughSubject<SendImageCompletion, Never>()
    
    override init() {
        super.init()
        getUserInfo()
        getUserPosts() 
    }
    
    func getUserInfo() {
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
                        self.userInfo = nil
                    case .loggedIn(let user):
                        self.userInfo = user
                    }
                }
            }).store(in: &bag)
    }
    
    func getUserPosts() {
        postsService.getUserPosts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    self.userPostState = .failure(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] posts in
                guard let self = self else { return }
                self.userPostState = .value(posts)
            }).store(in: &bag)
    }
    
    func updateProfileImage() {
        if let imageToSend = profileImage?.jpegData(compressionQuality: 0.8) {
            userService.uploadProfilePicture(imageData: imageToSend)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in
                    
                }, receiveValue: { [weak self] response in
                    guard let self else {return}
                    if response {
                        self.eventSubject.send(.completed)
                    } else {
                        self.eventSubject.send(.error)
                    }
                }).store(in: &bag)
        } else {
            self.eventSubject.send(.error)
        }
    }
    
    func deleteProfileImage() {
        userService.deleteProfilePicture()
            .receive(on: DispatchQueue.main)
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
    
    func addCommentToPost(comment: String, postId: String) {
        guard case .value(var posts) = userPostState else { return }
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            let newComment = Comment(id: UUID().uuidString, name: userInfo?.nickname ?? "Anonymous", description: comment)
            posts[index].comments.append(newComment)
            userPostState = .value(posts)
            
            postsService.addCommentToPost(comment: comment, postId: postId)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] success in
                    guard let self else { return }
                    if !success {
                        posts[index].comments.removeAll { $0.id == newComment.id }
                        self.userPostState = .value(posts)
                    }
                }).store(in: &bag)
        }
    }

    func likePost(postId: String) {
        guard case .value(var posts) = userPostState else { return }
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].nbOfLikes += 1
            userPostState = .value(posts)
            
            postsService.likePost(postId: postId)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] success in
                    guard let self else { return }
                    if !success {
                        posts[index].nbOfLikes -= 1
                        self.userPostState = .value(posts)
                    }
                }).store(in: &bag)
        }
    }
    
    func unlikePost(postId: String) {
        guard case .value(var posts) = userPostState else { return }
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].nbOfLikes -= 1
            userPostState = .value(posts)
            
            postsService.unlikePost(postId: postId)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] success in
                    guard let self else { return }
                    if !success {
                        posts[index].nbOfLikes += 1
                        self.userPostState = .value(posts)
                    }
                }).store(in: &bag)
        }
    }

    func postImage() {
        if newPostDescription.isEmpty {
            self.errorPostDescription = "Please add a description."
        } else {
            self.userPostState = .loading
            if let imageToSend = newPostImage?.jpegData(compressionQuality: 0.8) {
                postsService.uploadPost(imageData: imageToSend, description: newPostDescription)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        guard let self else { return }
                        switch completion {
                        case .failure:
                            self.eventSubjectForImages.send(.failed)
                        case .finished:
                            break
                        }
                    }, receiveValue: { [weak self] response in
                        guard let self else { return }
                        if response {
                            self.eventSubjectForImages.send(.sent)
                            self.getUserPosts()
                            self.newPostDescription = ""
                        } else {
                            self.eventSubjectForImages.send(.failed)
                        }
                    }).store(in: &bag)
            } else {
                self.eventSubjectForImages.send(.failed)
            }
        }
    }

    func deletePost(postId: String) {
        self.userPostState = .loading
        postsService.deletePost(postId: postId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] response in
                guard let self else {return}
                if response {
                    self.getUserPosts()
                } else {
                    self.eventSubject.send(.error)
                }
            }).store(in: &bag)
    }
}
