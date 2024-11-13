//
//  Model.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import Foundation

struct User {
    let id: Int
    let email: String
    let nickname: String
    let avatarUrl: String
    let isArtist: Bool
    let posts: [Post]
}

let userMocked = User(id: 1,
                email: "alexia.elena.aldea@gmail.com",
                nickname: "Allee",
                avatarUrl: "https://recorder.ro/wp-content/uploads/2024/10/IMG_1181-1920x1081.jpg",
                isArtist: true,
                posts: postsMocked)

