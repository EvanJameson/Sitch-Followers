//
//  Game.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 7/2/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import Foundation

struct GameWrapper: Codable {
    let data: [Game]
}

struct Game: Codable {
    let id: String
    let name: String
    var box_art_url: String
}
