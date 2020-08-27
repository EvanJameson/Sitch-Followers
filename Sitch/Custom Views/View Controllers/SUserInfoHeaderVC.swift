//
//  TFUserInfoHeaderVC.swift
//  Sitch
//
//  Created by Evan Jameson on 6/29/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

protocol SUserInfoHeaderVCDelegate: class {
    func updateUserInfo(for user: User)
    func setHeaderHeight(with height: CGFloat)
}

class SUserInfoHeaderVC: UIViewController {

    // UI Elements
    let avatarImageView             = SAvatarImageView(frame: .zero)
    let channelStatusImageView      = SChannelStatusImageView(frame: .zero)
    let usernameLabel               = STitleLabel(textAlignment: .left, fontSize: DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 26, frame: .zero)
    let broadcasterTypeImageView    = UIImageView()
    let broadcasterTypeLabel        = SSecondaryTitleLabel(textAlignment: .left, fontSize: 18, frame: .zero)
    let descriptionLabel            = SBodyLabel(textAlignment: .left, frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 20, height: CGFloat.greatestFiniteMagnitude))
    
    // Variable UI dimensions based on content
    var channeStatusImageWidth: CGFloat!
    var broadcasterTypeImageWidth: CGFloat!
    var descriptionLabelHeight: CGFloat!
    
    // Objects containing info
    var user: User!
    var channel: Channel?
    
    // Delegate that conforms to the protocol
    weak var delegate: SUserInfoHeaderVCDelegate!
    
    
    init(user: User, channel: Channel?, delegate: SUserInfoHeaderVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.user       = user
        self.channel    = channel
        self.delegate   = delegate
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate.updateUserInfo(for: user)
        view.addSubviews(avatarImageView, usernameLabel, broadcasterTypeImageView, broadcasterTypeLabel, descriptionLabel)
        configureUserUIElements()
        layoutUserUI()
        configureChannelUIElements()
        layoutChannelStatusUI()
    }
    
    
    /// Add channel status to view, and if the channel is live, add the animating border
    func configureChannelUIElements() {
        guard let channel = channel else { return }
        view.addSubviews(channelStatusImageView)
        if(channel.is_live) {
            avatarImageView.addLiveBorder(borderWidth: 4)
            channelStatusImageView.image        = Images.live
            channeStatusImageWidth              = 49
        } else {
            channelStatusImageView.image        = Images.offline
            channeStatusImageWidth              = 84
        }
    }
    
    
    /// Download the avatar image for the user, set username text, call other configure functions
    /// for broadcaster type and description
    func configureUserUIElements() {
        avatarImageView.downloadUserImage(for: user)
        usernameLabel.text = user.display_name
        configureBroadcasterType()
        configureDescriptionLabel()
    }
    
    
    /// Configure broadcasterTypeLabel and broadcasterTypeImageView. Set text, image, image width, and tint color.
    func configureBroadcasterType() {
        if(user.broadcaster_type.isEmpty) {
            broadcasterTypeLabel.text           = "User"
        } else {
            broadcasterTypeLabel.text           = user.broadcaster_type.capitalizingFirstLetter()
        }
        
        switch user.broadcaster_type {
        case "affiliate":
            broadcasterTypeImageView.image      = SFSymbols.affiliate
            broadcasterTypeImageWidth           = 28
        case "partner":
            broadcasterTypeImageView.image      = SFSymbols.partner
            broadcasterTypeImageWidth           = 36
        default:
            broadcasterTypeImageView.image      = SFSymbols.normalUser
            broadcasterTypeImageWidth           = 20
        }
        
        broadcasterTypeImageView.tintColor      = .secondaryLabel
    }
    
    
    /// Configure descriptionLabel. If not empty, set label to size itself based on the amount of text provided.
    /// Call function in delegate, UserInfoVC, to properly set the height constraint with the description labels
    /// height plus a default value for the rest of the header.
    func configureDescriptionLabel() {
        if(!user.description.isEmpty) {
            descriptionLabel.text               = user.description
            descriptionLabel.numberOfLines      = 0
            descriptionLabel.sizeToFit()
            descriptionLabelHeight              = descriptionLabel.frame.height + 20
            delegate.setHeaderHeight(with: descriptionLabelHeight + 110)
        } else {
            descriptionLabelHeight              = 0
            delegate.setHeaderHeight(with: 120)
        }
    }
    
    
    func layoutUserUI() {
        let padding: CGFloat = 20
        let textImagePadding: CGFloat = 12
        
        broadcasterTypeImageView.translatesAutoresizingMaskIntoConstraints = false
        let avatarImageViewConstraints = [
            "avatarImageView topConstraint"                 : avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            "avatarImageView leadingConstraint"             : avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            "avatarImageView widthConstraint"               : avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            "avatarImageView heightConstraint"              : avatarImageView.heightAnchor.constraint(equalToConstant: 90)
        ]
        let usernameLabelConstraints = [
            "usernameLabel topConstraint"                   : usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            "usernameLabel leadingConstraint"               : usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            "usernameLabel trailingConstraint"              : usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            "usernameLabel heightConstraint"                : usernameLabel.heightAnchor.constraint(equalToConstant: 38)
        ]
        let broadcasterTypeImageViewConstraints = [
            "broadcasterTypeImageView bottomConstraint"     : broadcasterTypeImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            "broadcasterTypeImageView leadingConstraint"    : broadcasterTypeImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            "broadcasterTypeImageView widthConstraint"      : broadcasterTypeImageView.widthAnchor.constraint(equalToConstant: broadcasterTypeImageWidth),
            "broadcasterTypeImageView heightConstraint"     : broadcasterTypeImageView.heightAnchor.constraint(equalToConstant: 20)
        ]
        let broadcasterTypeLabelConstraints = [
            "broadcasterType centerYConstraint"             : broadcasterTypeLabel.centerYAnchor.constraint(equalTo: broadcasterTypeImageView.centerYAnchor),
            "broadcasterType leadingConstraint"             : broadcasterTypeLabel.leadingAnchor.constraint(equalTo: broadcasterTypeImageView.trailingAnchor, constant: 5),
            "broadcasterType trailingConstraint"            : broadcasterTypeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            "broadcasterType heightConstraint"              : broadcasterTypeLabel.heightAnchor.constraint(equalToConstant: 20)
        ]
        let descriptionLabelConstraints = [
            "descriptionLabel topConstraint"                : descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
            "descriptionLabel leadingConstraint"            : descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            "descriptionLabel trailingConstraint"           : descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            "descriptionLabel heightConstraint"             : descriptionLabel.heightAnchor.constraint(equalToConstant: descriptionLabelHeight)
        ]
        
        UIHelper.identifyAndActivate(avatarImageViewConstraints, usernameLabelConstraints, broadcasterTypeImageViewConstraints, broadcasterTypeLabelConstraints, descriptionLabelConstraints)
    }
    
    
    func layoutChannelStatusUI() {
        guard let _ = channel else { return }
        let channelStatusImageViewConstraints = [
            "channelStatusImageView topConstraint"          : channelStatusImageView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -13),
            "channelStatusImageView centerXConstraint"      : channelStatusImageView.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            "channelStatusImageView widthConstraint"        : channelStatusImageView.widthAnchor.constraint(equalToConstant: channeStatusImageWidth),
            "channelStatusImageView heightConstraint"       : channelStatusImageView.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        UIHelper.identifyAndActivate(channelStatusImageViewConstraints)
    }

}
