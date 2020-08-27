//
//  StreamsVC.swift
//  Sitch
//
//  Created by Evan Jameson on 7/15/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

class StreamsVC: SDataLoadingVC {

    // UI Elements
    private let refreshControl  = UIRefreshControl()
    let tableView               = UITableView()
    
    // Data for display
    var streams: [Stream] = []
    var isLoadingMoreStreams: Bool = false
    var paginationCursor: String? = nil
    
    
    // MARK: - Overrides
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getStreams()
    }
    
    
    // MARK: - Configure Funcs

    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title                = "Top Streams"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.refreshControl    = refreshControl
        refreshControl.tintColor    = Colors.baseText
        refreshControl.addTarget(self, action: #selector(refreshStreams(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Streams ...")
        
        tableView.frame             = view.bounds
        tableView.rowHeight         = 315
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.removeExcessCells()
        tableView.register(StreamCell.self, forCellReuseIdentifier: StreamCell.reuseID)
    }
    
    
    // MARK: - UI Modification Funcs
    
    
    func resetStreams() {
        paginationCursor = nil
        streams = []
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func updateUI(with streams: [Stream]) {
        self.streams.append(contentsOf: streams)
        
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
        }
    }
    
    
    // MARK: - Selector Funcs
    
    
    @objc private func refreshStreams(_ sender: Any) {
        guard !isLoadingMoreStreams else { return }
        
        resetStreams()
        getStreams()
    }
    
    
    // MARK: - Network Calls
    
    
    func getStreams() {
        self.isLoadingMoreStreams = true
        self.showLoadingView()
        
        NetworkManager.shared.getStreams(paginationCursor: paginationCursor) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let streamWrapper):
                self.paginationCursor = streamWrapper.pagination.cursor
                self.updateUI(with: streamWrapper.data)
                
            case .failure:
                self.presentTFAlertOnMainThread(title: "Something went wrong", message: "Unable to get streams 🤯", buttonTitle: "Ok")
            }
            self.isLoadingMoreStreams = false
            self.dismissLoadingView()
        }
    }
}


// MARK: - Extensions


extension StreamsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return streams.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StreamCell.reuseID) as! StreamCell
        let stream = streams[indexPath.row]
        cell.set(stream: stream)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stream = streams[indexPath.item]
        let destVC = UserInfoVC(username: stream.user_name, title: nil, largeTitle: false, inModal: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        destVC.username     = stream.user_name
        let navController   = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let screenHeight    = scrollView.frame.size.height

        if offsetY > contentHeight - screenHeight {
            guard !isLoadingMoreStreams else { return }
            
            getStreams()
        }
    }
}


