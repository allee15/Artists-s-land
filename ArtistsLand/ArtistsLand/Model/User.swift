//
//  Model.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import Foundation

struct UserResponse {
    let token: String
    let user: User
}

struct User {
    let id: String
    let email: String
    let nickname: String
    let avatarUrl: String
    let isArtist: Bool
    let balance: Double
    let level: Int
    let createdAt: Date
    let posts: [Post]
}

let userMocked = User(id: "1",
                      email: "alexia.elena.aldea@gmail.com",
                      nickname: "Allee",
                      avatarUrl: "https://media.istockphoto.com/id/1368424494/photo/studio-portrait-of-a-cheerful-woman.jpg?s=612x612&w=0&k=20&c=ISNDV3ZXeNU6VvDhR7KXFd6y0saq4Eji15cep_Gj8Eg=",
                      isArtist: true,
                      balance: 0.0,
                      level: 5,
                      createdAt: Date(),
                      posts: postsMocked)

