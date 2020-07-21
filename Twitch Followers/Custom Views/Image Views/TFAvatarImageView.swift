//
//  TFAvatarImageView.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 6/25/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class TFAvatarImageView: UIImageView {

    let cache            = NetworkManager.shared.cache
    let placeholderImage = Images.avatarPlaceholder
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        layer.cornerRadius  = 10
        clipsToBounds       = true
        image               = placeholderImage
        layer.borderColor   = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0)
        layer.borderWidth   = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func addLiveBorder(borderWidth: CGFloat) {
        let baseColor: UIColor = .systemPurple
        let liveColor: UIColor = .systemRed
        
        layer.borderColor = baseColor.cgColor
        layer.borderWidth = borderWidth
        animateBorderColor(toColor: liveColor, duration: 1.5)
    }
    
    
    func downloadUserImage(for user: User) {
        let cacheKey = NSString(string: user.display_name)
        
        if let image = cache.object(forKey: cacheKey) {
            DispatchQueue.main.async { self.image = image }
            return
        }
        
        NetworkManager.shared.downloadAvatarImage(from: user.profile_image_url, for: user.display_name) { image in
            DispatchQueue.main.async { self.image = image }
        }
    }
    
    
    func downloadFollowerImage(for follower: Follower) {
        let cacheKey = NSString(string: follower.from_name)
        
        if let image = cache.object(forKey: cacheKey) {
            DispatchQueue.main.async { self.image = image }
            return
        }
        
        NetworkManager.shared.getUser(for: follower.from_name) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                NetworkManager.shared.downloadAvatarImage(from: user.profile_image_url, for: follower.from_name) { image in
                    DispatchQueue.main.async { self.image = image }
                }
                
            case .failure:
                DispatchQueue.main.async { self.image = Images.avatarPlaceholder }
            }
        }
    }
}
