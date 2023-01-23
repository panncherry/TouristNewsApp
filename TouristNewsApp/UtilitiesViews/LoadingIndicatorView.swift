//
//  LoadingIndicatorView.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/22/23.
//

import UIKit

class LoadingIndicatorView: UIView {

    private let label: UILabel
    private let containerView: UIView
    let loadingIndicator: UIActivityIndicatorView
    
    override init(frame: CGRect) {
        label = UILabel()
        containerView = UIView()
        loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        super.init(frame: frame)
                
        containerView.layer.cornerRadius = 12
        containerView.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(80)
            make.center.equalToSuperview()
        }
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.color = .white
        containerView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-12)
        }

        label.text = "Loading..."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        containerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loadingIndicator.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
