//
//  TFError.swift
//  Sitch
//
//  Created by Evan Jameson on 6/25/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import Foundation


enum SError: String, Error {
    case invalidUsername    = "This username created an invalid request. Please try again."
    case invalidGame        = "This game created an invalid request. Please try again."
    case unableToComplete   = "Unable to complete your request. Please check your internet connection."
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data recieved from the server was invalid. Please try again."
    case unableToFavorite   = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "You've already favorited this user. You must really like them!"
    case noFollowers        = "This user has no followers\n🥺"
}
