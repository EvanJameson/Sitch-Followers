//
//  UIView+Ext.swift
//  Sitch
//
//  Created by Evan Jameson on 6/25/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Use variadic parameter to pass one or more subviews to be added
    /// to the callers view
    /// - Parameter views: One or more UIViews converted into array by variadic parameter
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
    
    
    /// Sets constraints of a view to all edges of the specified superview
    /// - Parameter superview: the view to be pinned to, the "container view"
    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    
    // credit for the animation function:
    //  https://stackoverflow.com/questions/28934948/how-to-animate-bordercolor-change-in-swift
    //  https://stackoverflow.com/questions/8083138/how-to-do-a-native-pulse-effect-animation-on-a-uibutton-ios
    /// Animates the border of a view by constantly changing it to the specified color and back to the original
    /// - Parameters:
    ///   - toColor: color to be changed to
    ///   - duration: how long the animation takes
    func animateBorderColor(toColor: UIColor, duration: Double) {
        let animation:CABasicAnimation  = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue             = layer.borderColor
        animation.toValue               = toColor.cgColor
        animation.duration              = duration
        animation.autoreverses          = true
        animation.repeatCount           = .greatestFiniteMagnitude
        animation.timingFunction        = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        layer.add(animation, forKey: "borderColor")
        layer.borderColor               = toColor.cgColor
    }
}

