//
//  TouristDetailsView.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import UIKit
import SnapKit

class TouristDetailsView: UIView {
    
    let tourist: TouristData
    let nameLabel: UILabel
    let emailLabel: UILabel
    let locationLabel: UILabel
    let timestampLabel: UILabel
    
    init(tourist: TouristData) {
        self.tourist = tourist
        nameLabel = UILabel()
        emailLabel = UILabel()
        locationLabel = UILabel()
        timestampLabel = UILabel()
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        nameLabel.numberOfLines = 0
        nameLabel.font = .titleFont
        nameLabel.text = "Name: \(tourist.name)"
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        emailLabel.numberOfLines = 0
        emailLabel.font = .titleFont
        emailLabel.text = "Email: \(tourist.email)"
        addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        
        locationLabel.numberOfLines = 0
        locationLabel.font = .titleFont
        locationLabel.text = "Location: \(tourist.location)"
        addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
        }
        
        timestampLabel.numberOfLines = 0
        timestampLabel.font = .titleFont
        timestampLabel.text = "Create At: \(tourist.createdAt)"
        addSubview(timestampLabel)
        timestampLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(locationLabel.snp.bottom).offset(4)
        }
    }
    
}
