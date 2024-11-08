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
    
    func getSearchPosts(searchItem: String) -> AnyPublisher<String, Error> {
        return postsApi.getSearchPosts(searchItem: searchItem)
            .eraseToAnyPublisher()
    }
}
