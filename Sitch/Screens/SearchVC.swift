//
//  SearchVC.swift
//  Sitch
//
//  Created by Evan Jameson on 6/24/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    // UI Elements
    let logoImageView = UIImageView()
    let usernameTextField = STextField()
    let callToActionButton = SButton()
    
    var isUsernameEntered: Bool { return !usernameTextField.text!.isEmpty }
    
    
    // MARK: - Overrides

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(logoImageView, usernameTextField, callToActionButton)
        configureViewController()
        configureUIElements()
        layoutUI()
        createKeyboardDismissTapGesture()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    // MARK: - Configure Funcs
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    
    /// Configures the logo image, the textfield, and the button
    func configureUIElements() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.sitchLogo
        
        usernameTextField.delegate = self
        
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        callToActionButton.set(backgroundColor: .systemTeal, title: "Find Streamer")
    }
    
    
    func layoutUI() {
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 100 : 200
        let heightConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 90 : 120
        let widthConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 250 : 330
        let logoImageViewConstraints = [
            "logoImageView topConstraint"           : logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
            "logoImageView centerXConstraint"       : logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            "logoImageView heightConstraint"        : logoImageView.heightAnchor.constraint(equalToConstant: heightConstraintConstant),
            "logoImageView widthConstraint"         : logoImageView.widthAnchor.constraint(equalToConstant: widthConstraintConstant)
        ]
        let userNameTextFieldConstraints = [
            "usernameTextField topConstraint"       : usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            "usernameTextField leadingConstraint"   : usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            "usernameTextField trailingConstraint"  : usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            "usernameTextField heightConstraint"    : usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        let callToActionButtonConstraints = [
            "callToActionButton bottomConstraint"   : callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            "callToActionButton leadingConstraint"  : callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            "callToActionButton trailingConstraint" : callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            "callToActionButton heightConstraint"   : callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        UIHelper.identifyAndActivate(logoImageViewConstraints, userNameTextFieldConstraints, callToActionButtonConstraints)
    }
    
    
    // MARK: - Helper Funcs
    
    
    func createKeyboardDismissTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func pushFollowerListVC() {
        guard isUsernameEntered else {
            presentTFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for 😁", buttonTitle: "Ok")
            return
        }
        
        usernameTextField.resignFirstResponder()
        
        let userInfoVC = UserInfoVC(username: usernameTextField.text!, title: "User Info", largeTitle: true, inModal: false)
        navigationController?.pushViewController(userInfoVC, animated: true)
        
        //let followerListVC      = FollowerListVC(username: usernameTextField.text!)
        //navigationController?.pushViewController(followerListVC, animated: true)
    }
}


// MARK: - Extensions


extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
