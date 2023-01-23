//
//  TouristsViewController.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import UIKit

class TouristsViewController: UIViewController, CustomViewProviding {
    
    typealias CustomView = TouristsView
    private var pageIndex: Int = 0
    private var isFetchInProgress: Bool = false
    private var shouldFetchNewData: Bool = false
    private let refreshControl = UIRefreshControl()
    private var touristsPageInfo: TouristPageInfo? = TouristsViewModel.touristsPageInfo
    private var touristsList: [TouristData] = TouristsViewModel.touristsList?.data.toArray() ?? []
    
    private var totalPages: Int {
        if let pageInfo = TouristsViewModel.touristsPageInfo {
            return pageInfo.totalPages
        }
        
        return 2
    }
    override func loadView() {
        super.loadView()
        view = TouristsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialzeNewsFeedTableView()
        
        title = "Tourists"
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
        fetchTouristsDataFromLocalRealm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Fetch data if there is internet connection, to display updated data after view did appear
        if Reachability.shared.isConnectedToNetwork() {
            shouldFetchNewData = true
            fetchTouristData()
        } else {
            shouldFetchNewData = false
        }
    }
    
    /// Fetch newsfeed data
    private func fetchTouristData() {
        if touristsList.isEmpty {
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
        
        TouristsViewModel.shared.fetchTouristsData(for: pageIndex) { [weak self] result in
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
    
    private func updateData(_ newData: [TouristData]) {
        if shouldFetchNewData {
            touristsList = newData
            shouldFetchNewData = false
        } else {
            for data in newData {
                if !touristsList.contains(data) {
                    touristsList.append(data)
                }
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.customView.tableView.reloadData()
        }
    }
    
}

// MARK: - UITableView Delegate, UITableView DataSource
extension TouristsViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// Inititalze table view
    private func initialzeNewsFeedTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        customView.tableView.rowHeight = UITableView.automaticDimension
        customView.tableView.estimatedRowHeight = UITableView.automaticDimension
        customView.tableView.register(TouristTableViewCell.self, forCellReuseIdentifier: TouristTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return touristsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TouristTableViewCell.identifier, for: indexPath) as? TouristTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(touristsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tourist = touristsList[indexPath.row]
        let vc = TouristDetailsViewController(tourist)
        navigationController?.pushViewController(vc, animated: true)
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
            fetchTouristData()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Save update news feed data in local realm when finished scrolling
        saveTouristDataInLocalRealm()
    }
    
}



// MARK: Helper Functions
extension TouristsViewController {
    
    /// Reset page index and fetch new data on pull to refresh if network connection available
    /// Otherise, dismiss refresh control and present network error alert
    @objc func fetchNewDataOnPull() {
        if Reachability.shared.isConnectedToNetwork() {
            pageIndex = 0
            shouldFetchNewData = true
            fetchTouristData()
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
extension TouristsViewController {
    
    /// Get Tourists from local realm
    private func fetchTouristsDataFromLocalRealm() {
        guard let tourists = RealmDatabaseManager.shared.getTouristsList() else {
            if Reachability.shared.isConnectedToNetwork() {
                fetchTouristData()
            } else {
                presentNetworkErrorAlert(title: "Uh-oh",
                                         message: "Your internet connection appears to be offline. Please try again later.")
            }
            return
        }
        
        let touristData = tourists.data.toArray()
        if !touristData.isEmpty {
            touristsList = touristData
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.customView.tableView.reloadData()
        }
    }
    
    /// Save updated data in local realm
    private func saveTouristDataInLocalRealm() {
        if !touristsList.isEmpty {
            DispatchQueue.main.async { [weak self] in
                if let list = self?.touristsList {
                    RealmDatabaseManager.shared.saveTouristsList(list)
                }
            }
        }
    }
}
