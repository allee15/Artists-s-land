//
//  Post.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 08.11.2024.
//

import Foundation

struct Post {
    let id: String
    let description: String
    let date: String
    let artistName: String
    let artistId: String
    let artistAvatarUrl: String
    var nbOfLikes: Int
    let postUrl: String
    var comments: [Comment]
}

struct Comment {
    let id: String
    let name: String
    let description: String
}
