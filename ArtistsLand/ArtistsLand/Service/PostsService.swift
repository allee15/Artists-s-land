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
    
    func getPosts() {
        postsApi.getPosts()
    }
    
    func getPostsForArtist(id: Int64) {
        postsApi.getPostsForArtist(id: id)
    }
    
    func likePost(postId: Int64) {
        postsApi.likePost(postId: postId)
    }
    
    func addCommentToPost(comment: Comment, postId: Int64) {
        postsApi.addCommentToPost(comment: comment, postId: postId)
    }
    
    func postImage() {
        postsApi.postImage()
    }
    
    func deletePost(postId: Int64) {
        postsApi.deletePost(postId: postId)
    }
    
    func reportPost(postId: Int64) {
        postsApi.reportPost(postId: postId)
    }
}
