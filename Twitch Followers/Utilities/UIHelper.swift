//
//  UIHelper.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 6/25/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

enum UIHelper {
    
    /// Creates a UICollectionViewFlowLayout by calculating the available width usingthe given view and
    /// specified number of columns
    /// - Parameters:
    ///   - view: used for its width to calculate available width for layout
    ///   - numColumns: desired number of columns
    /// - Returns: UICollectionViewFlowLayout that fits within the given view with a specific number of columns
    static func createColumnFlowLayout(in view: UIView, numColumns: CGFloat) -> UICollectionViewFlowLayout {
        let width                       = view.bounds.width
        let padding: CGFloat            = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth              = width - (padding * 2) - (minimumItemSpacing * (numColumns - 1))
        let itemWidth                   = availableWidth / numColumns
        
        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.sectionInset         = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
 
    
    /// Set identifier fields of each constraint to its corresponding key and activate it
    /// - Parameter constraints: Variadic parameter, 1 or more dictionaries containing "identifier: constraint" "key: value" pairs
    static func identifyAndActivate(_ constraints: [String: NSLayoutConstraint]...) {
        for dict in constraints {
            for (id, constraint) in dict {
                constraint.identifier   = id
                constraint.isActive     = true
            }
        }
    }
}
