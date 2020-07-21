//
//  Channel.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 6/29/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import Foundation

struct ChannelWrapper: Codable, Hashable {
    let data: [Channel]
}

struct Channel: Codable, Hashable {
    let display_name: String
    let game_id: String
    let is_live: Bool
    let title: String
    let started_at: String
}
