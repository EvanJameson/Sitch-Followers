//
//  NSLayoutConstraint+Ext.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 6/28/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    /// Changes the description value of a constraint it contain the constraints id.
    /// Extremely useful when constraints are broken.
    override public var description: String {
        let constraintId = identifier ?? "No Identifier"
        return "id: \(constraintId), constant: \(constant)"
    }
}
