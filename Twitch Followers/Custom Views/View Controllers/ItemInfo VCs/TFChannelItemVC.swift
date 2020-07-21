//
//  TFChannelItemVC.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 7/2/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

protocol TFChannelItemVCDelegate: class {
    func didTapTwitchChannel(for user: User)
}

class TFChannelItemVC: TFItemInfoVC {

    // Delegate that confroms to protocol
    weak var delegate: TFChannelItemVCDelegate!
    
    
    init(user: User, channel: Channel?, delegate: TFChannelItemVCDelegate) {
        super.init(user: user, channel: channel)
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
        actionButton.set(backgroundColor: .systemPurple, title: "Twitch Channel")
        guard let channel = channel else { return } // Make sure we find the channel
        if (!channel.is_live) { return }            // Don't request for game if channel isn't live
        
        NetworkManager.shared.getGameInfo(for: channel.game_id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let game):
                DispatchQueue.main.async { self.add(childVC: TFChannelInfoVC(channel: channel, game: game), to: self.itemInfo) }
                
            case .failure:
                DispatchQueue.main.async { self.add(childVC: TFChannelInfoVC(channel: channel, game: nil), to: self.itemInfo) }
            }
        }
    }
    
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    override func actionButtonTapped() {
        delegate.didTapTwitchChannel(for: user)
    }
}
