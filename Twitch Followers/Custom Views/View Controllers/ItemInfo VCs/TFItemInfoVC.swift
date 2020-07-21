//
//  TFItemInfoVC.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 7/2/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

protocol TFItemInfoVCDelegate: class {
    func didTapTwitchChannel(for user: User)
    func didTapGetFollowers(for user: User)
}

class TFItemInfoVC: UIViewController {

    // UI Elements
    let itemInfo        = UIView()
    let actionButton    = TFButton()

    // Objects containing info
    var user: User!
    var channel: Channel?
    
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }

    
    init(user: User, channel: Channel?) {
        super.init(nibName: nil, bundle: nil)
        self.user       = user
        self.channel    = channel
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(itemInfo, actionButton)
        configureBackgroundView()
        configureActionButton()
        layoutUI()
    }
    
    
    private func configureBackgroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor    = .secondarySystemBackground
    }

    
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func actionButtonTapped() {}
    
    
    private func layoutUI() {
        let padding: CGFloat        = 20
        var itemInfoHeight: CGFloat = 0
        if let _ = channel { itemInfoHeight = 240 } // by making channel nil, when TFFollowerITemVC calls this method, it will still have layout 0
        
        itemInfo.translatesAutoresizingMaskIntoConstraints = false
        
        let itemInfoConstraints = [
            "itemInfo topConstraint"            : itemInfo.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            "itemInfo leadingConstraint"        : itemInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            "itemInfo trailingConstraint"       : itemInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            "itemInfo heightConstraint"         : itemInfo.heightAnchor.constraint(equalToConstant: itemInfoHeight)
        ]
        let actionButtonConstraints = [
            "actionButton bottomConstraint"     : actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            "actionButton leadingConstraint"    : actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            "actionButton trailingConstraint"   : actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            "actionButton heightConstraint"     : actionButton.heightAnchor.constraint(equalToConstant: 44)
        ]
        UIHelper.identifyAndActivate(itemInfoConstraints, actionButtonConstraints)
    }
}
