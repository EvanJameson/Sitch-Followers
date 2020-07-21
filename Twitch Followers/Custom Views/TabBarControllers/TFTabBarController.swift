//
//  TFTabBarController.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 6/24/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class TFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    func configure() {
        UITabBar.appearance().tintColor = .systemPurple
        self.viewControllers            = [createSearchNC(), createStreamsNC(), createFavoritesNC()]
    }
    
    
    func createSearchNC() -> UINavigationController {
        let searchVC        = SearchVC()
        searchVC.title      = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    
    func createStreamsNC() -> UINavigationController {
        let streamsVC = StreamsVC()
        streamsVC.title = "Top Streams"
        streamsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 1)
        
        return UINavigationController(rootViewController: streamsVC)
    }
    
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesListVC        = FavoritesListVC()
        favoritesListVC.title      = "Favorites"
        favoritesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        
        return UINavigationController(rootViewController: favoritesListVC)
    }
}
