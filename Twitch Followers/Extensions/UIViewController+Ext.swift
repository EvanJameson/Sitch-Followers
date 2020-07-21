//
//  UIViewController+Ext.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 6/26/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    
    /// Presents an alert viewcontroller over the current viewcontroller
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message of the alert
    ///   - buttonTitle: text on the button
    func presentTFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = TFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle   = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    
    /// Presents a safari viewcontroller using the specified url
    /// - Parameter url: safari viewcontroller destination
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemPurple
        present(safariVC, animated: true)
    }
}
