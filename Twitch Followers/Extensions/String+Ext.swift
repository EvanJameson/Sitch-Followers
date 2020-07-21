//
//  String+Ext.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 7/8/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

extension String {
    
    /// Capitalizes the first letter of a string
    /// - Returns: New string with capitalized letter
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
