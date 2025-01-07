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
}
