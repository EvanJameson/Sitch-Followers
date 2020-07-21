//
//  TFGameImageView.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 7/2/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class TFGameImageView: UIImageView {

    let cache            = NetworkManager.shared.cache
    let placeholderImage = Images.backgroundPlaceholder

    
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
        image               = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }

    
    func downloadGameImage(for game: Game) {
        NetworkManager.shared.downloadGameImage(from: game.box_art_url, for: game.name) { image in
            DispatchQueue.main.async { self.image = image }
        }
    }
}
