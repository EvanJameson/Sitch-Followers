//
//  SFollowerItemVC.swift
//  Sitch
//
//  Created by Evan Jameson on 7/2/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

protocol SFollowerItemVCDelegate: class {
    func didTapGetFollowers(for user: User)
}

class SFollowerItemVC: SItemInfoVC {

    // Delegate that conforms to protocol
    weak var delegate: SFollowerItemVCDelegate!
    
    
    init(user: User, delegate: SFollowerItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    private func configure() {
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }

}
