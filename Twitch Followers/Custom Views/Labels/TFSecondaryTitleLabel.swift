//
//  TFSecondaryTitleLabel.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 6/29/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class TFSecondaryTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat, frame: CGRect) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    
    private func configure () {
        textColor                   = .label
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.90
        lineBreakMode               = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
