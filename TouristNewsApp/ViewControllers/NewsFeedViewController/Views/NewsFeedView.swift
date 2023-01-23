//
//  NewsFeedView.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import UIKit
import SnapKit

class NewsFeedView: UIView {
    
    let tableView: UITableView
    var loadingIndicatorView: LoadingIndicatorView
    
    override init(frame: CGRect) {
        loadingIndicatorView = LoadingIndicatorView()
        tableView = UITableView(frame: .zero, style: .grouped)
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///  Configure UI
    private func configureUI() {
        addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.tableHeaderView?.removeFromSuperview()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        tableView.layoutIfNeeded()
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    /// Present loading indicator view
    func presentLoadingIndicatorView() {
            addSubview(loadingIndicatorView)
            loadingIndicatorView.snp.makeConstraints { make in
                make.width.equalTo(90)
                make.height.equalTo(80)
                make.center.equalToSuperview()
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.loadingIndicatorView.loadingIndicator.startAnimating()
            }
    }
    
    /// Dismiss loading indicator view
    func dismissLoadingIndicatorView() {
        loadingIndicatorView.loadingIndicator.stopAnimating()
        loadingIndicatorView.removeFromSuperview()
    }
    
}
