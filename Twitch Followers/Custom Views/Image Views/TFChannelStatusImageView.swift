//
//  TFChannelStatusImageView.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 6/29/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class TFChannelStatusImageView: UIImageView {

        let defaultImage = Images.offline
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        func configure() {
            layer.cornerRadius  = 5
            clipsToBounds       = true
            image               = defaultImage
            translatesAutoresizingMaskIntoConstraints = false
        }
}
