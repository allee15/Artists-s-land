//
//  JSONParsers.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 18.10.2024.
//

import Foundation
import SwiftyJSON

class JSONParsers {
    static func parseJsonUser(json: JSON) -> User {
        return User(
            id: json["id"].intValue,
            email: json["email"].stringValue,
            nickname: json["username"].stringValue,
            firstName: json["first_name"].stringValue,
            lastName: json["last_name"].stringValue,
            avatarUrl: json["avatar"].stringValue,
            isArtist: json["isArtist"].boolValue
        )
    }
}
