//
//  SBodyLabel.swift
//  Sitch
//
//  Created by Evan Jameson on 6/26/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class SBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(textAlignment: NSTextAlignment, frame: CGRect) {
        self.init(frame: frame)
        self.textAlignment = textAlignment
    }
    
    
    private func configure () {
        textColor                           = .secondaryLabel
        font                                = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory   = true
        adjustsFontSizeToFitWidth           = true
        minimumScaleFactor                  = 0.75
        lineBreakMode                       = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }

}
