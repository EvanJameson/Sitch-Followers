//
//  Follower.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 6/25/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import Foundation

struct FollowerWrapper: Codable, Hashable {
    let total: Int
    let data: [Follower]
    let pagination: Pagination
}

struct Follower: Codable, Hashable {
    let from_id: String
    let from_name: String
}

struct Pagination: Codable, Hashable {
    let cursor: String
}
