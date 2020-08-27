//
//  Stream.swift
//  Sitch
//
//  Created by Evan Jameson on 7/15/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import Foundation

struct StreamWrapper: Codable {
    let data: [Stream]
    let pagination: Pagination
}

struct Stream: Codable {
    let user_id: String
    let user_name: String
    let game_id: String
    let title: String
    let viewer_count: Int
    let thumbnail_url: String 
}
