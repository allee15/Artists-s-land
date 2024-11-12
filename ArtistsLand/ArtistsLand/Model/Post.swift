//
//  Post.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 08.11.2024.
//

import Foundation

struct Post {
    let id: Int64
    let description: String
    let date: Date
    let artistName: String
    let artistId: Int64
    let artistAvatarUrl: String
    let nbOfLikes: Int64
    let postUrl: String
    let comments: [Comment]
}

struct Comment {
    let id: Int64
    let name: String
    let description: String
}

let postsMocked: [Post] = [
    Post(id: 1, description: "da", date: Date(), artistName: "eu", artistId: 1, artistAvatarUrl: "https://recorder.ro/wp-content/uploads/2024/10/IMG_1181-1920x1081.jpg", nbOfLikes: 23, postUrl: "https://recorder.ro/wp-content/uploads/2024/10/IMG_1181-1920x1081.jpg",
         comments: [Comment(id: 1, name: "frumos", description: "kfsjngvkejfrbsdhjgknf")]),
    Post(id: 2, description: "nu", date: Date(), artistName: "tu", artistId: 1, artistAvatarUrl: "https://recorder.ro/wp-content/uploads/2024/10/IMG_1181-1920x1081.jpg", nbOfLikes: 45, postUrl: "https://recorder.ro/wp-content/uploads/2024/10/IMG_1181-1920x1081.jpg",
         comments: [Comment(id: 2, name: "interesant", description: "ewhrgnfuirejkhf")])
]
