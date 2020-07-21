//
//  TFDataLoadingVC.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 6/25/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class TFDataLoadingVC: UIViewController {

    var containerView: UIView!
    
    /// Displays loading viewcontroller over current viewcontroller
    func showLoadingView() {
        // View that will contain the loading vc
        containerView                   = UIView(frame: view.bounds)
        containerView.backgroundColor   = .systemBackground
        containerView.alpha             = 0
        view.addSubview(containerView)
        
        // Animate the appearance of the container view fading in
        UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.8 }
        
        // Constrain the activity indicator to the center of the screen
        let activityIndicator = UIActivityIndicatorView(style: .large)
        let constraints = [
            "activityIndicator centerYConstraint" : activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            "activityIndicator centerXConstraint" : activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Add activity indicator to the container
        containerView.addSubview(activityIndicator)
        
        // Activate constraints
        UIHelper.identifyAndActivate(constraints)
        
        // Begin animating the activity indicator
        activityIndicator.startAnimating()
    }
    
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
    
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView      = TFEmptyStateView(message: message)
        emptyStateView.frame    = view.bounds
        view.addSubview(emptyStateView)
    }
}
