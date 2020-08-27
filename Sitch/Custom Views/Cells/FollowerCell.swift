//
//  FollowerCell.swift
//  Sitch
//
//  Created by Evan Jameson on 6/25/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class FollowerCell: UICollectionViewCell {

    // Reuse ID for cell registration
    static let reuseID          = "Follower Cell"
    
    // UI Elements
    var avatarImageView         = SAvatarImageView(frame: .zero)
    let usernameLabel           = STitleLabel(textAlignment: .center, fontSize: DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 14 : 16, frame: .zero)
    var channelStatusImageView  = SChannelStatusImageView(frame: .zero)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBaseElements()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func configureBaseElements() {
        addSubviews(avatarImageView, usernameLabel)
        let padding: CGFloat = 8
        let avatarImageViewConstraints = [
            "avatarImageView topConstraint"             : avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            "avatarImageView leadingConstraint"         : avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            "avatarImageView trailingConstraint"        : avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            "avatarImageView heightConstraint"          : avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
        ]
        let usernameLabelConstraints = [
            "usernameLabel topConstraint"               : usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            "usernameLabel leadingConstraint"           : usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            "usernameLabel trailingConstraint"          : usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            "usernameLabel heightConstraint"            : usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        UIHelper.identifyAndActivate(avatarImageViewConstraints, usernameLabelConstraints)
    }
    
    
    private func configureChannelStatus() {
        channelStatusImageView.image = Images.live
        
        addSubview(channelStatusImageView)
        
        let channelStatusImageViewConstraints = [
            "channelStatusImageView topConstraint"      : channelStatusImageView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -13),
            "channelStatusImageView centerXConstraint"  : channelStatusImageView.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            "channelStatusImageView widthConstraint"    : channelStatusImageView.widthAnchor.constraint(equalToConstant: 49),
            "channelStatusImageView heightConstraint"   : channelStatusImageView.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        UIHelper.identifyAndActivate(channelStatusImageViewConstraints)
    }
    
    
    /// Called when the cell is being set to be seen in the tableview.
    /// Downloads the users avatar image, sets the username, and adds live channel
    /// UI elements if the channel is live
    /// - Parameter follower: the user with the info to populate the cell
    func set(follower: Follower) {
        avatarImageView.downloadFollowerImage(for: follower)
        usernameLabel.text = follower.from_name
        avatarImageView.layer.borderWidth = 0 // fixes a bug where users had a live border that didn't need it
        channelStatusImageView.image = UIImage() // fixes a bug where users had a live badge that weren't

        NetworkManager.shared.getChannel(for: follower.from_name) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let channel):
                if (channel.is_live) {
                    DispatchQueue.main.async {
                        self.avatarImageView.addLiveBorder(borderWidth: 5)
                        self.configureChannelStatus()
                    }
                }
            case .failure:
                return
            }
        }
    }
}
