//
//  NewsFeedViewController.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import UIKit


final class NewsFeedViewController: UIViewController, CustomViewProviding {
    
    typealias CustomView = NewsFeedView
    
    private var pageIndex: Int = 0
    private var isFetchInProgress: Bool = false
    private var shouldFetchNewData: Bool = false
    private let refreshControl = UIRefreshControl()
    private var newsFeedPageInfo: NewsFeedPageInfo? = NewsFeedViewModel.newsFeedPageInfo
    private var newsFeedList: [NewsFeedData] = NewsFeedViewModel.newsFeedList?.data.toArray() ?? []
    
    private var totalPages: Int {
        if let pageInfo = NewsFeedViewModel.newsFeedPageInfo {
            return pageInfo.totalPages
        }
        
        return 2
    }
    
    override func loadView() {
        super.loadView()
        view = NewsFeedView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialzeNewsFeedTableView()
        title = "News Feed"
        view.backgroundColor = .cellBackgroundColor
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if !Reachability.shared.isConnectedToNetwork() {
            presentNetworkErrorAlert(title: "Uh-oh",
                                     message: "Your internet connection appears to be offline. Please try again later.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load data from local realm every time view will appear
        fetchNewsFeedDataFromLocalRealm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Fetch data if there is internet connection, to display updated data after view did appear
        if Reachability.shared.isConnectedToNetwork() {
            shouldFetchNewData = true
            fetchNewsFeedData()
        } else {
            shouldFetchNewData = false
        }
    }
    
    /// Fetch newsfeed data
    private func fetchNewsFeedData() {
        if newsFeedList.isEmpty {
            customView.presentLoadingIndicatorView()
        }
        
        guard !isFetchInProgress else {
            dismissRefreshControl()
            return
        }
        
        pageIndex += 1
        
        guard pageIndex <= totalPages else {
            return
        }
        
        NewsFeedViewModel.shared.fetchNewsFeedData(for: pageIndex) { [weak self] result in
            self?.isFetchInProgress = true
            
            switch result {
            case .success(let data):
                self?.updateData(data)
                self?.isFetchInProgress = false
                
            case .failure(_):
                self?.presentNetworkErrorAlert(title: "Uh-oh",
                                               message: "There is an error getting data. Please try again later.")
            }
            
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.customView.dismissLoadingIndicatorView()
            }
        }
    }
    
    private func updateData(_ newData: [NewsFeedData]) {
        if shouldFetchNewData {
            newsFeedList = newData
            shouldFetchNewData = false
        } else {
            for data in newData {
                if !newsFeedList.contains(data) {
                    newsFeedList.append(data)
                }
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.customView.tableView.reloadData()
        }
    }
    
}

// MARK: - UITableView Delegate, UITableView DataSource
extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// Inititalze table view
    private func initialzeNewsFeedTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        customView.tableView.addSubview(refreshControl)
        customView.tableView.rowHeight = UITableView.automaticDimension
        customView.tableView.estimatedRowHeight = UITableView.automaticDimension
        customView.tableView.register(NewsFeedTableViewCell.self, forCellReuseIdentifier: NewsFeedTableViewCell.identifier)
        customView.tableView.register(NewsFeedMediaSupportTableViewCell.self, forCellReuseIdentifier: NewsFeedMediaSupportTableViewCell.identifier)
        refreshControl.addTarget(self, action: #selector(fetchNewDataOnPull), for: .valueChanged)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFeedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !newsFeedList.isEmpty, newsFeedList.count > indexPath.row else {
            return UITableViewCell()
        }
        
        let newsFeed = newsFeedList[indexPath.row]        
        if !newsFeed.multiMedia.toArray().isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedMediaSupportTableViewCell.identifier, for: indexPath) as? NewsFeedMediaSupportTableViewCell else {
                return UITableViewCell()
            }
                    
            cell.configure(newsFeedList[indexPath.row])
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedTableViewCell.identifier, for: indexPath) as? NewsFeedTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(newsFeedList[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            customView.tableView.tableFooterView = spinner
            customView.tableView.tableFooterView?.isHidden = false
            
            if !Reachability.shared.isConnectedToNetwork() {
                presentNetworkErrorAlert(title: "Uh-oh", message: "Your internet connection appears to be offline. Please try again later.")
            }
        }
    }
    
    /// Fetch more data on scroll
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let yPostion = scrollView.contentOffset.y
        
        if yPostion > customView.tableView.contentSize.height - 100 - scrollView.frame.size.height {
            guard !isFetchInProgress else {
                return
            }
            
            // Fetch more data when user scroll to the bottom of the screen
            fetchNewsFeedData()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Save update news feed data in local realm when finished scrolling
        saveNewsFeedDataInLocalRealm()
    }
}


// MARK: Helper Functions
extension NewsFeedViewController {
    
    /// Reset page index and fetch new data on pull to refresh if network connection available
    /// Otherise, dismiss refresh control and present network error alert
    @objc func fetchNewDataOnPull() {
        if Reachability.shared.isConnectedToNetwork() {
            pageIndex = 0
            shouldFetchNewData = true
            fetchNewsFeedData()
        } else {
            presentNetworkErrorAlert(title: "Uh-oh",
                                     message: "Your internet connection appears to be offline. Please try again later.")
        }
    }
    
    /// Dismiss refresh control
    private func dismissRefreshControl() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    /// Display network error alert
    private func presentNetworkErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController?.present(alert, animated: true) {
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl.endRefreshing()
                self?.customView.tableView.reloadData()
            }
        }
    }
    
}


// MARK: - Realm helper function
extension NewsFeedViewController {
    
    /// Get NewsFeeds from local realm
    private func fetchNewsFeedDataFromLocalRealm() {
        guard let newsFeeds = RealmDatabaseManager.shared.getNewsFeedList() else {
            if Reachability.shared.isConnectedToNetwork() {
                fetchNewsFeedData()
            } else {
                presentNetworkErrorAlert(title: "Uh-oh",
                                         message: "Your internet connection appears to be offline. Please try again later.")
            }
            return
        }
        
        let newsFeedData = newsFeeds.data.toArray()
        if !newsFeedData.isEmpty {
            newsFeedList = newsFeedData
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.customView.tableView.reloadData()
        }
    }
    
    /// Save updated data in local realm
    private func saveNewsFeedDataInLocalRealm() {
        if !newsFeedList.isEmpty {
            DispatchQueue.main.async { [weak self] in
                if let list = self?.newsFeedList {
                    RealmDatabaseManager.shared.saveNewsFeedList(list)
                }
            }
        }
    }
}
