//
//  TouristTableViewCell.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import UIKit
import SnapKit
import SDWebImage

class TouristTableViewCell: UITableViewCell {
    
    let containerView: UIView
    let nameLabel: UILabel
    let emailLabel: UILabel
    let locationLabel: UILabel
    let timestampLabel: UILabel
    
    static let identifier = "TouristTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        nameLabel = UILabel()
        emailLabel = UILabel()
        containerView = UIView()
        locationLabel = UILabel()
        timestampLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    func configure(_ tourist: TouristData) {
        // Configure user name
        nameLabel.text = "Name: \(tourist.name)"
        
        // Configure email
        emailLabel.text = "Email: \(tourist.email)"
        
        // Configure location
        locationLabel.text = "Location: \(tourist.location)"
        
        // Configure timestamp
        let timestamp = tourist.createdAt
        if let dateToDisplay = timestamp.getDateString() {
            timestampLabel.text = "Created At: \(dateToDisplay)"
        }
    }
    
    /// Set up UI
    private func setupUI() {
        contentView.backgroundColor = .cellBackgroundColor
        containerView.backgroundColor = .containerBackgroundColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.layer.cornerRadius = 12
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        nameLabel.numberOfLines = 0
        nameLabel.font = .titleFont
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        emailLabel.numberOfLines = 0
        emailLabel.font = .titleFont
        containerView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        
        locationLabel.numberOfLines = 0
        locationLabel.font = .titleFont
        containerView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
        }
        
        timestampLabel.numberOfLines = 0
        timestampLabel.font = .titleFont
        containerView.addSubview(timestampLabel)
        timestampLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-20)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(locationLabel.snp.bottom).offset(4)
        }
    }
    
    /// Reset data
    private func reset() {
        nameLabel.text = nil
        emailLabel.text = nil
        locationLabel.text = nil
        timestampLabel.text = nil
    }
}
