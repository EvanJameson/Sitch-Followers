//
//  TFViewerCountView.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 7/15/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class TFViewerCountView: UIView {

    let viewerCountLabel = TFTitleLabel(textAlignment: .center, fontSize: 14, frame:.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(viewerCountLabel)
        configureUIElements()
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(viewerCount: Int) {
        self.init(frame: .zero)
        viewerCountLabel.text = "\(String(viewerCount)) viewers"
    }
    
    
    func configureUIElements() {
        backgroundColor       = .tertiarySystemBackground
        layer.cornerRadius    = 5
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func layoutUI() {
        let viewerCountLabelConstraints = [
            "viewerCountLabel centerXConstraint" : viewerCountLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            "viewerCountLabel centerYConstraint" : viewerCountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        UIHelper.identifyAndActivate(viewerCountLabelConstraints)
    }

}
