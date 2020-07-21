//
//  UITableView+Ext.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 7/15/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// Reload tablview on main thread
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
    
    /// Removes excess cells from tableview that doesn't fill screen
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
