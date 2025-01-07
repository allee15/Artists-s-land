//
//  PostsService.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 08.11.2024.
//

import Foundation
import Combine

class PostsService {
    static let shared = PostsService()
    private let postsApi = PostsApi()
    var bag = Set<AnyCancellable>()
    
    private init() { }
    
    func getPosts() -> AnyPublisher<[Post], Error> {
        postsApi.getPosts()
            .eraseToAnyPublisher()
    }
    
    func getUserPosts() -> AnyPublisher<[Post], Error> {
        postsApi.getUserPosts()
            .eraseToAnyPublisher()
    }
    
    func uploadPost(imageData: Data, description: String) -> AnyPublisher<Bool, Error> {
        postsApi.uploadPost(imageData: imageData, description: description)
            .eraseToAnyPublisher()
    }
    
    func deletePost(postId: String) -> AnyPublisher<Bool, Error> {
        postsApi.deletePost(postId: postId)
            .eraseToAnyPublisher()
    }
    
    func getArtistPosts(artistId: String) -> AnyPublisher<[Post], Error> {
        postsApi.getArtistPosts(artistId: artistId)
            .eraseToAnyPublisher()
    }
    
    func likePost(postId: String) -> AnyPublisher<Bool, Error> {
        postsApi.likePost(postId: postId)
            .eraseToAnyPublisher()
    }
    
    func unlikePost(postId: String) -> AnyPublisher<Bool, Error> {
        postsApi.unlikePost(postId: postId)
            .eraseToAnyPublisher()
    }
    
    func addCommentToPost(comment: String, postId: String) -> AnyPublisher<Bool, Error> {
        postsApi.addCommentToPost(comment: comment, postId: postId)
            .eraseToAnyPublisher()
    }
    
    func reportPost(postId: String) -> AnyPublisher<Bool, Error> {
        postsApi.reportPost(postId: postId)
            .eraseToAnyPublisher()
    }
}
