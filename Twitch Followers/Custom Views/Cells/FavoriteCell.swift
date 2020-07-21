//
//  FavoriteCell.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 7/16/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    // Reuse ID for cell registration
    static let reuseID          = "FavoriteCell"
    
    // UI Elements
    let avatarImageView         = TFAvatarImageView(frame: .zero)
    let usernameLabel           = TFTitleLabel(textAlignment: .left, fontSize: DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 22 : 26, frame: .zero)
    var channelStatusImageView  = TFChannelStatusImageView(frame: .zero)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(avatarImageView, usernameLabel)
        configureUIElements()
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Called when the cell is being set to be seen in the tableview.
    /// Downloads the users avatar image, sets the username, and adds live channel
    /// UI elements if the channel is live
    /// - Parameter favorite: the user with the info to populate the cell
    func set(favorite: User) {
        avatarImageView.downloadUserImage(for: favorite)
        usernameLabel.text = favorite.display_name
        avatarImageView.layer.borderWidth = 0 // fixes a bug where users had a live border that didn't need it
        channelStatusImageView.image = UIImage() // fixes a bug where users had a live badge that weren't
        
        // check if channel is live for border setup
        NetworkManager.shared.getChannel(for: favorite.login) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let channel):
                if (channel.is_live) {
                    DispatchQueue.main.async {
                        self.avatarImageView.addLiveBorder(borderWidth: 3)
                        self.configureChannelStatus()
                    }
                }
            case .failure:
                break
            }
        }
    }
    
    
    func configureUIElements() {
        accessoryType = .disclosureIndicator
    }
    
    
    func layoutUI() {
        let padding: CGFloat = 12
        let avatarImamgeViewConstraints = [
            "avatarImageView centerYConstraint" : avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            "avatarImageView leadingConstraint" : avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            "avatarImageView heightConstraint"  : avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            "avatarImageView widthConstraint"   : avatarImageView.widthAnchor.constraint(equalToConstant: 60)
        ]
        let usernameLabelConstraints = [
            "usernameLabel centerYConstraint"   : usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            "usernameLabel leadingConstraint"   : usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            "usernameLabel trailingConstraint"  : usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            "usernameLabel heightConstraint"    : usernameLabel.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        UIHelper.identifyAndActivate(avatarImamgeViewConstraints, usernameLabelConstraints)
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
}
