//
//  FollowerListVC.swift
//  Twitch Followers
//
//  Created by Evan Jameson on 6/25/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class FollowerListVC: TFDataLoadingVC {
    
    enum Section { case main }
    
    // Info for network calls
    var username: String!
    var id: String!
    var paginationCursor: String!
    var total: Int!
    
    // Data for display
    var followers: [Follower]           = []
    var filteredFollowers: [Follower]   = []
    var hasMoreFollowers                = true
    var isSearching                     = false
    var isLoadingMoreFollowers          = false
    
    // UI Elements
    var collectionView: UICollectionView!
    var datasource: UICollectionViewDiffableDataSource<Section, Follower>!
    

    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username   = username
        title           = "Followers"
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Overrides
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getUser(username: username)
        configureDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    // MARK: - Configure Funcs
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createColumnFlowLayout(in: view, numColumns: 2))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    
    func configureDataSource() {
        datasource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    
    func configureSearchController() {
        let searchController                                    = UISearchController()
        searchController.searchResultsUpdater                   = self
        searchController.searchBar.placeholder                  = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation   = false
        navigationItem.searchController                         = searchController
    }
    
    
    // MARK: - Network Calls
    
    
    func getUser(username: String) {
        DispatchQueue.main.async { self.showLoadingView() }
        NetworkManager.shared.getUser(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                self.id = user.id
                self.getFollowers(id: user.id, paginationCursor: nil)
                
            case .failure(let error):
                self.presentTFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
            
            self.isLoadingMoreFollowers = false
        }
    }
    
    
    func getFollowers(id: String, paginationCursor: String?) {
        if let _ = paginationCursor { DispatchQueue.main.async { self.showLoadingView() } }

        self.isLoadingMoreFollowers = true
        
        NetworkManager.shared.getFollowers(for: id, paginationCursor: paginationCursor) { [weak self] result in
            guard let self = self else { return } // unwraps optional self
            self.dismissLoadingView()
            
            switch result {
            case .success(let followerWrapper):
                self.paginationCursor   = followerWrapper.pagination.cursor
                self.total              = followerWrapper.total
                self.updateUI(with: followerWrapper.data)
                
            case .failure(let error):
                switch error {
                case .noFollowers:
                    DispatchQueue.main.async { self.showEmptyStateView(with: error.rawValue, in: self.view) }
                default:
                    self.presentTFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
                }
                
            }
            
            self.isLoadingMoreFollowers = false
        }
    }
    
    
    // MARK: - Update UI
    
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        
        DispatchQueue.main.async { self.datasource.apply(snapshot, animatingDifferences: true) }
    }
    
    
    func updateUI(with followers: [Follower]) {
        if followers.count < Limits.followersPerPage { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
            let message = "This user doesn't have any followers \n🥺"
            DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
            return
        }
        self.updateData(on: self.followers)
    }
}


// MARK: - Extensions


extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let screenHeight    = scrollView.frame.size.height

        if offsetY > contentHeight - screenHeight {
            // Make sure the user has more followers and didn't already request for more.
            // Can lead to problems on slow connection
            guard hasMoreFollowers, !isLoadingMoreFollowers, !isSearching else { return }
            
            getFollowers(id: id, paginationCursor: paginationCursor)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray     = isSearching ? filteredFollowers : followers
        let follower        = activeArray[indexPath.item]
        let destVC          = UserInfoVC(username: follower.from_name, title: nil, largeTitle: false, inModal: true)
        
        destVC.delegate     = self
        let navController   = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}


extension FollowerListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter {$0.from_name.lowercased().contains(filter.lowercased())}
        updateData(on: filteredFollowers)
    }
}


extension FollowerListVC: UserInfoVCDelegate {
    
    func didRequestFollowers(for user: User) {
        self.username   = user.display_name // ?
        title           = user.display_name
       
        
        followers.removeAll()
        filteredFollowers.removeAll()
        updateData(on: followers)
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        showLoadingView()
        getFollowers(id: user.id, paginationCursor: nil)
    }
}
