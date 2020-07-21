//
//  TFChannelInfoVC.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 7/2/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit


class TFChannelInfoVC: UIViewController {

    // UI Elements
    let gameImageView       = TFGameImageView(frame: .zero)
    let gameNameLabel       = TFTitleLabel(textAlignment: .left, fontSize: 24, frame: CGRect(x: 0, y: 0, width: 250, height: CGFloat.greatestFiniteMagnitude))
    let streamTitleLabel    = TFSecondaryTitleLabel(textAlignment: .left, fontSize: 18, frame: CGRect(x: 0, y: 0, width: 250, height: CGFloat.greatestFiniteMagnitude))

    // Variable UI dimensions based on content
    var gameNameLabelHeight: CGFloat = 30
    var streamTitleLabelHeight: CGFloat = 40
    
    // Objects containing info
    var channel: Channel!
    var game: Game?
    
    
    init(channel: Channel, game: Game?) {
        super.init(nibName: nil, bundle: nil)
        self.channel    = channel
        self.game       = game
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(gameImageView, streamTitleLabel, gameNameLabel)
        configure()
    }
    
    
    func configure() {
        if let game = game {
            configureUIElements(game: game)
            layoutUI()
            return
        }
    }
    
    
    /// Downloads game box art, configures the game name label and stream title label
    /// - Parameter game: Game object containing all necessary info to populate UI
    func configureUIElements(game: Game) {
        gameImageView.downloadGameImage(for: game)
        
        gameNameLabel.text              = game.name
        gameNameLabel.numberOfLines     = 0
        gameNameLabel.sizeToFit()
        gameNameLabelHeight             = gameNameLabel.frame.height
        
        streamTitleLabel.text           = channel.title
        streamTitleLabel.numberOfLines  = 3
        streamTitleLabel.sizeToFit()
        streamTitleLabelHeight          = streamTitleLabel.frame.height + 38
    }
    
    
    func layoutUI() {
        let padding: CGFloat = 0
        let textImagePadding: CGFloat = 12
        
        let gameImageViewConstraints = [
            "gameImageView topConstraint"           : gameImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            "gameImageView leadingConstraint"       : gameImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            "gameImageView widthConstraint"         : gameImageView.widthAnchor.constraint(equalToConstant: 52),
            "gameImageView heightConstraint"        : gameImageView.heightAnchor.constraint(equalToConstant: 72)
        ]
        let gameNameLabelConstraints = [
            "gameNameLabel topConstraint"           :  gameNameLabel.topAnchor.constraint(equalTo: gameImageView.topAnchor, constant: -5),
            "gameNameLabel leadingConstraint"       :  gameNameLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: textImagePadding),
            "gameNameLabel trailingConstraint"      :  gameNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            "gameNameLabel heightConstraint"        :  gameNameLabel.heightAnchor.constraint(equalToConstant: gameNameLabelHeight)
        ]
        let streamTitleLabelConstraints = [
            "streamTitleLabel topConstraint"        : streamTitleLabel.topAnchor.constraint(equalTo: gameImageView.bottomAnchor, constant: textImagePadding * 0.5),
            "streamTitleLabel leadingConstraint"    : streamTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            "streamTitleLabel trailingConstraint"   : streamTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            "streamTitleLabel heightConstraint"     : streamTitleLabel.heightAnchor.constraint(equalToConstant: streamTitleLabelHeight)
        ]
        
        UIHelper.identifyAndActivate(gameImageViewConstraints, gameNameLabelConstraints, streamTitleLabelConstraints)
    }
}
