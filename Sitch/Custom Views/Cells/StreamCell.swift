//
//  StreamCell.swift
//  Sitch
//
//  Created by Evan Jameson on 7/15/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class StreamCell: UITableViewCell {
    
    // Shared cache object to retrieve images quickly
    let cache = NetworkManager.shared.cache

    // Reuse ID for cell registration
    static let reuseID          = "StreamCell"
    
    // UI Elements
    let thumbnailImageView      = SThumbnailImageView(frame: .zero)
    var viewerCountView         = SViewerCountView(frame: .zero)
    let channelStatusImageView  = SChannelStatusImageView(frame: .zero)
    let avatarImageView         = SAvatarImageView(frame: .zero)
    let streamerLabel           = STitleLabel(textAlignment: .left, fontSize: 24, frame: .zero)
    let gameTitleLabel          = SSecondaryTitleLabel(textAlignment: .left, fontSize: 16, frame: .zero)
    let streamTitleLabel        = SSecondaryTitleLabel(textAlignment: .left, fontSize: 16, frame: .zero)
    
    // Constraint that is changed when cells are set with different viewer counts
    var viewerCountViewWidthConstraint: NSLayoutConstraint!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(thumbnailImageView, viewerCountView, channelStatusImageView, avatarImageView, streamerLabel, gameTitleLabel, streamTitleLabel)
        configureUIElements()
        layoutUI()
    }
    
    
    override func prepareForReuse() {
        NSLayoutConstraint.deactivate([viewerCountViewWidthConstraint])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Called when the cell is being set to be seen in the tableview.
    /// Downloads the stream thumbnail, sets the viewer count view, adds the
    /// channel status image, sets the avatar image, sets the streamers name (username)
    /// sets the game name, and the stream title
    /// - Parameter stream: the stream with the info to populate the cell
    func set(stream: Stream) {
        thumbnailImageView.downloadThumbnail(for: stream.thumbnail_url)
        setViewerCountView(with: String(stream.viewer_count))
        channelStatusImageView.image = Images.live
        setAvatarImageView(for: stream.user_name)
        streamerLabel.text = stream.user_name
        setGameName(for: stream.game_id)
        streamTitleLabel.text = stream.title
    }
    
    
    /// Sets the viewer count label as well as sets the constraint based on the size of the viewer count label
    /// - Parameter viewCount: number of viewers currently the watching the stream
    func setViewerCountView(with viewCount: String) {
        let viewerCountViewWidth: CGFloat = (CGFloat(viewCount.count) * 7.0) + 75.0
        viewerCountView.viewerCountLabel.text = "\(viewCount) viewers"
        
        let newViewerCountWidthConstraint = [
            "viewerCountView widthConstraint" : viewerCountView.widthAnchor.constraint(equalToConstant:  viewerCountViewWidth)
        ]
        viewerCountViewWidthConstraint = newViewerCountWidthConstraint["viewerCountView widthConstraint"]
        
        UIHelper.identifyAndActivate(newViewerCountWidthConstraint)
    }
    
   
    func setAvatarImageView(for username: String) {
        if let image = cache.object(forKey: NSString(string: username)) {
            DispatchQueue.main.async { self.avatarImageView.image = image }
            return
        }
        
        NetworkManager.shared.getUser(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                self.avatarImageView.downloadUserImage(for: user)
            case .failure:
                DispatchQueue.main.async { self.avatarImageView.image = Images.avatarPlaceholder }
            }
        }
    }
    
    
    func setGameName(for id: String) {
        NetworkManager.shared.getGameInfo(for: id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let game):
                DispatchQueue.main.async { self.gameTitleLabel.text = game.name }
            case .failure:
                DispatchQueue.main.async { self.gameTitleLabel.text = "Unknown" }
            }
        }
    }

    
    func configureUIElements() {
        gameTitleLabel.textColor = .systemGray
        streamTitleLabel.numberOfLines = 1
    }
    
    
    func layoutUI() {
        let verticalPadding: CGFloat    = 12
        let horizontalPadding: CGFloat  = 20
        let textImagePadding: CGFloat   = 10
        
        let thumbnailImageViewConstraints = [
            "thumbnailImageView topConstraint"          : thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: verticalPadding),
            "thumbnailImageView leadingConstraint"      : thumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalPadding),
            "thumbnailImageView trailingConstraint"     : thumbnailImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -horizontalPadding),
            "thumbnailImageView heightConstraint"       : thumbnailImageView.heightAnchor.constraint(equalToConstant: 200)
        ]
        let viewerCountViewConstraints = [
            "viewerCountView topConstraint"             : viewerCountView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor, constant: verticalPadding * 0.5),
            "viewerCountView trailingConstraint"        : viewerCountView.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: -verticalPadding * 0.5),
            "viewerCountView heightConstraint"          : viewerCountView.heightAnchor.constraint(equalToConstant: 20)
        ]
        let channelStatusImageViewConstraints = [
            "channelStatusImageView bottomConstraint"   : channelStatusImageView.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: -verticalPadding * 0.5),
            "channelStatusImageView centerXConstraint"  : channelStatusImageView.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: -verticalPadding * 0.5),
            "channelStatusImageView widthConstraint"    : channelStatusImageView.widthAnchor.constraint(equalToConstant: 49),
            "channelStatusImageView heightConstraint"   : channelStatusImageView.heightAnchor.constraint(equalToConstant: 20)
        ]
        let avatarImageViewConstraints = [
            "avatarImageView topConstraint"             : avatarImageView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: verticalPadding),
            "avatarImageView leadingConstraint"         : avatarImageView.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor),
            "avatarImageView widthConstraint"           : avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            "avatarImageView heightConstraint"          : avatarImageView.heightAnchor.constraint(equalToConstant: 50)
        ]
        let streamerLabelConstraints = [
            "streamerLabel topConstraint"               : streamerLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            "streamerLabel leadingConstraint"           : streamerLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            "streamerLabel trailingConstraint"          : streamerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -horizontalPadding),
            "streamerLabel heightConstraint"            : streamerLabel.heightAnchor.constraint(equalToConstant: 26)
        ]
        let gameTitleLabelConstraints = [
            "gameTitleLabel bottomConstraint"           : gameTitleLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            "gameTitleLabel leadingConstraint"          : gameTitleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            "gameTitleLabel trailingConstraint"         : gameTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -horizontalPadding),
            "gameTitleLabel heightConstraint"           : gameTitleLabel.heightAnchor.constraint(equalToConstant: 18)
            
        ]
        let streamTitleLabelConstraints = [
            "streamTitleLabel topConstraint"            : streamTitleLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
            "streamTitleLabel leadingConstraint"        : streamTitleLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            "streamTitleLabel trailingConstraint"       : streamTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -horizontalPadding),
            "streamTitleLabel heightConstraint"         : streamTitleLabel.heightAnchor.constraint(equalToConstant: 18)
        ]
        
        UIHelper.identifyAndActivate(thumbnailImageViewConstraints, viewerCountViewConstraints, channelStatusImageViewConstraints, avatarImageViewConstraints, streamerLabelConstraints, gameTitleLabelConstraints, streamTitleLabelConstraints)
    }
}
