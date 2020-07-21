//
//  User.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 6/25/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import Foundation

struct UserWrapper: Codable {
    let data: [User]
}

struct User: Codable, Equatable {
    let id: String
    let login: String
    let display_name: String
    let broadcaster_type: String
    let description: String
    let profile_image_url: String
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.login == rhs.login
    }
}
