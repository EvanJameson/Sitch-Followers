//
//  TFFollowerItemVC.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 7/2/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

protocol TFFollowerItemVCDelegate: class {
    func didTapGetFollowers(for user: User)
}

class TFFollowerItemVC: TFItemInfoVC {

    // Delegate that conforms to protocol
    weak var delegate: TFFollowerItemVCDelegate!
    
    
    init(user: User, delegate: TFFollowerItemVCDelegate) {
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
