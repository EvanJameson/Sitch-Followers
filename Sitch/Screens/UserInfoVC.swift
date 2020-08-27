//
//  UserInfoVC.swift
//  Sitch
//
//  Created by Evan Jameson on 6/25/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

protocol UserInfoVCDelegate: class {
    func didRequestFollowers(for user: User)
}

class UserInfoVC: UIViewController {
    
    // UI Elements
    let scrollView          = UIScrollView()
    let contentView         = UIView()
    let headerView          = UIView()
    let itemViewOne         = UIView()
    let itemViewTwo         = UIView()
    
    // Variable UI dimensions based on content
    var userInfoHeaderHeight: CGFloat!
    var itemViewOneHeight: CGFloat = 84
    var itemViewTwoHeight: CGFloat = 84
    var contentViewHeight: CGFloat = ScreenSize.height
    var constraint: NSLayoutConstraint!
    
    // Data for display
    var user: User!
    var username: String!
    var channel: Channel!
    
    // Different presentation modes
    var inModal: Bool!
    var largeTitle: Bool!
    
    // Optional delegate that confroms to protocol
    weak var delegate: UserInfoVCDelegate?
    
    
    // MARK: - Init
    
    
    init(username: String, title: String?, largeTitle: Bool, inModal: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.username   = username
        self.title      = title
        self.largeTitle = largeTitle
        self.inModal    = inModal
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Overrides
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        getChannel()
        configureViewController()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = largeTitle
    }
    
    
    // MARK: - Configure Funcs
    
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        let contentViewConstraints = [
            "contentView widthConstraint"   : contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            "contentView heightConstraint"  : contentView.heightAnchor.constraint(equalToConstant: contentViewHeight)
        ]
        constraint = contentViewConstraints["contentView heightConstraint"]
        
        UIHelper.identifyAndActivate(contentViewConstraints)
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        if (inModal) {
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
            navigationItem.leftBarButtonItem = doneButton
        }
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    // called once we make the network call for the channel info
    func layoutUI() {
        let padding: CGFloat = 20
        
        contentView.addSubviews(headerView, itemViewOne, itemViewTwo)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        itemViewOne.translatesAutoresizingMaskIntoConstraints = false
        itemViewTwo.translatesAutoresizingMaskIntoConstraints = false
        
        let headerViewConstraints = [
            "headerView leadingConstraint"      : headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            "headerView trailingConstraint"     : headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            "headerView topConstraint"          : headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            // Height is set later once we know the size of the description label
        ]
        let itemViewOneConstraints = [
            "itemViewOne leadingConstraint"     : itemViewOne.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            "itemViewOne trailingConstraint"    : itemViewOne.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            "itemViewOne topConstraint"         : itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            "itemViewOne heightConstraint"      : itemViewOne.heightAnchor.constraint(equalToConstant: itemViewOneHeight)
        ]
        let itemViewTwoConstraints = [
            "itemViewTwo leadingConstraint"     : itemViewTwo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            "itemViewTwo trailingConstraint"    : itemViewTwo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            "itemViewTwo topConstraint"         : itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            "itemViewTwo heightConstraint"      : itemViewTwo.heightAnchor.constraint(equalToConstant: 84)
        ]
        
        UIHelper.identifyAndActivate(headerViewConstraints, itemViewOneConstraints, itemViewTwoConstraints)
    }
    
    
    func displayChannelInfo(isLive: Bool) {
        self.itemViewOneHeight = isLive ? 240 : 84
        
        DispatchQueue.main.async {
            self.changeContentViewHeight()
            self.layoutUI()
        }
    }
    
    
    // MARK: - Network Calls
    
    
    func getChannel() {
        NetworkManager.shared.getChannel(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result{
            case .success(let channel):
                self.getUser(channel: channel)
                self.displayChannelInfo(isLive: channel.is_live)
                
            case .failure:
                self.getUser(channel: nil)
                self.displayChannelInfo(isLive: false)
            }
        }
    }
    
    
    func getUser(channel: Channel?) {
        NetworkManager.shared.getUser(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result{
            case .success(let user):
                DispatchQueue.main.async { self.configureUIElements(user: user, channel: channel) }
                
            case .failure(let error):
                self.presentTFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    // MARK: - UI Modification Funcs
    
    
    func changeContentViewHeight() {
        NSLayoutConstraint.deactivate([constraint])
        
        let newContentViewHeight = ["contentView heightConstraint"  : contentView.heightAnchor.constraint(equalToConstant: contentViewHeight)]
        constraint = newContentViewHeight["contentView heightConstraint"]
        
        UIHelper.identifyAndActivate(newContentViewHeight)
        
    }
    
    
    func configureUIElements(user: User, channel: Channel?) {
        self.add(childVC: SChannelItemVC(user: user,channel: channel, delegate: self), to: self.itemViewOne)
        self.add(childVC: SFollowerItemVC(user: user, delegate: self), to: self.itemViewTwo)
        self.add(childVC: SUserInfoHeaderVC(user: user, channel: channel, delegate: self), to: self.headerView)
    }
    
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    // MARK: - Selector Funcs
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    

    @objc func addButtonTapped() {
        guard let favorite = user else {
            self.presentTFAlertOnMainThread(title: "Something went wrong", message: SError.unableToFavorite.rawValue, buttonTitle: "Ok")
            return
        }
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else {
                self.presentTFAlertOnMainThread(title: "Success!", message: "You have successfully favorited this user 🎉", buttonTitle: "Ok")
                return
            }
            
            self.presentTFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
        
    }
}


// MARK: - Extensions


extension UserInfoVC: SChannelItemVCDelegate {    
    func didTapTwitchChannel(for user: User) {
        guard let url = URL(string: "https://www.twitch.tv/\(user.display_name)") else {
            presentTFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid.", buttonTitle: "Ok")
            return
        }

        presentSafariVC(with: url)
    }
}


extension UserInfoVC: SFollowerItemVCDelegate {
    
    func didTapGetFollowers(for user: User) {
        guard let _ = delegate else{
            let followerListVC = FollowerListVC(username: username)
            navigationController?.pushViewController(followerListVC, animated: true)
            return
        }
        
        self.delegate!.didRequestFollowers(for: user)
        dismissVC()
    }
}

extension UserInfoVC: SUserInfoHeaderVCDelegate {
    func updateUserInfo(for user: User) {
        self.user = user
    }
    
    func setHeaderHeight(with height: CGFloat) {
        // Modify header height based on description
        let headerViewConstraint = ["headerView heightConstraint" : headerView.heightAnchor.constraint(equalToConstant: height)]
        UIHelper.identifyAndActivate(headerViewConstraint)
        userInfoHeaderHeight = height
        
        
        // Modify size of overall content based on header height
        let buffer: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 60 : 0
        contentViewHeight = userInfoHeaderHeight + itemViewOneHeight + itemViewTwoHeight + buffer
        
        let usedScreen = contentViewHeight / ScreenSize.height
        
        if(usedScreen > 0.7 && usedScreen < 0.85) { // Fixes bug that would cause scroll view to get stuck
            contentViewHeight += 75
        }

        DispatchQueue.main.async{ self.changeContentViewHeight() }
    }
}
