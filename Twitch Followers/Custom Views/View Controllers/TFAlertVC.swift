//
//  TFAlertVCViewController.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 6/26/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class TFAlertVC: UIViewController {

    // UI Elements
    var containerView       = TFAlertContainerView()
    let titleLabel          = TFTitleLabel(textAlignment: .center, fontSize: 20, frame: .zero)
    let messageLabel        = TFBodyLabel(textAlignment: .center, frame: .zero)
    let actionButton        = TFButton(backgroundColor: .systemPink, title: "Ok")
    
    // String for label texts
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    
    init(alertTitle: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.alertTitle     = alertTitle
        self.message        = message
        self.buttonTitle    = buttonTitle
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(containerView, titleLabel, actionButton, messageLabel)
        configureUIElements()
        layoutUI()
    }
    
    
    func configureViewController() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    }
    
    
    /// Configures the alerts title, button, and message
    func configureUIElements() {
        titleLabel.text = alertTitle ?? "Something went wrong"
        
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        messageLabel.text           = message ?? "Unable to complete request"
        messageLabel.numberOfLines  = 4
    }
    
    
    func layoutUI() {
        let padding: CGFloat    = 20
        let containerViewConstraints = [
            "containerView centerYConstraint"       : containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            "containerView centerXConstraint"       : containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            "containerView widthConstraint"         : containerView.widthAnchor.constraint(equalToConstant: 280),
            "containerView heightConstraint"        : containerView.heightAnchor.constraint(equalToConstant: 220)
        ]
        let titleLabelConstraints = [
            "titleLabel topConstraint"              : titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            "titleLabel leadingConstraint"          : titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            "titleLabel trailingConstraint"         : titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            "titleLabel heightConstraint"           : titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ]
        let actionButtonConstraints = [
            "actionButton bottomConstraint"         : actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            "actionButton leadingConstraint"        : actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            "actionButton trailingConstraint"       : actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            "actionButton heightConstraint"         : actionButton.heightAnchor.constraint(equalToConstant: 44)
        ]
        let messageLabelConstraints = [
            "messageLabel topConstraint"            : messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            "messageLabel leadingConstraint"        : messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            "messageLabel trailingConstraint"       : messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            "messageLabel bottomConstraint"         : messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ]
        
        UIHelper.identifyAndActivate(containerViewConstraints, titleLabelConstraints, actionButtonConstraints, messageLabelConstraints)
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
}
