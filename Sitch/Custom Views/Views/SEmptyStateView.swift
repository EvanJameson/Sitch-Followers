//
//  SEmptyStateView.swift
//  Sitch
//
//  Created by Evan Jameson on 6/26/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class SEmptyStateView: UIView {

    let messageLabel    = STitleLabel(textAlignment: .center, fontSize: 28, frame:.zero)
    let logoImageView   = UIImageView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(messageLabel, logoImageView)
        configureUIElements()
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    
    private func configureUIElements() {
        messageLabel.numberOfLines  = 3
        messageLabel.textColor      = .secondaryLabel
        
        logoImageView.image = Images.emptyState
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layoutUI() {
        let labelCenterYConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? -80 : -150
        let messageLabelConstraints = [
            "messageLabel centerYConstraint"     : messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenterYConstant),
            "messageLabel leadingConstraint"     : messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            "messageLabel trailingConstraint"    : messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            "messageLabel heightConstraint"      : messageLabel.heightAnchor.constraint(equalToConstant: 200)
        ]
        
        let logoBottomConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 80 : 10
        let logoImageViewConstraints = [
            "logoImageView widthConstraint"      : logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.5),
            "logoImageView heightConstraint"     : logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.5),
            "logoImageView centerXConstraint"    : logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            "logoImageView bottomAnchor"         : logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: logoBottomConstant)
        ]
        
        UIHelper.identifyAndActivate(messageLabelConstraints, logoImageViewConstraints)
    }
}
