//
//  SAlertContainerView.swift
//  Sitch
//
//  Created by Evan Jameson on 6/26/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class SAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func configure() {
        backgroundColor       = .systemBackground
        layer.cornerRadius    = 16
        layer.borderWidth     = 2
        layer.borderColor     = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
