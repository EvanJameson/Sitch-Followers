//
//  SThumbnailImageView.swift
//  Sitch
//
//  Created by Evan Jameson on 7/15/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class SThumbnailImageView: UIImageView {

    let cache = NetworkManager.shared.cache
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func downloadThumbnail(for url: String) {
        let cacheKey = NSString(string: url)
        
        if let image = cache.object(forKey: cacheKey) {
            DispatchQueue.main.async { self.image = image }
            return
        }
        
        NetworkManager.shared.downloadTumbnailImage(from: url) { [weak self] image in
            guard let self = self else { return }
            guard let image = image else { return }
            
            DispatchQueue.main.async { self.image = image }
        }
    }
    
    
    func configure() {
        layer.cornerRadius  = 10
        clipsToBounds       = true
        image               = Images.backgroundPlaceholder
        translatesAutoresizingMaskIntoConstraints = false
    }

}
