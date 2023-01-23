//
//  NewsFeedMediaSupportTableViewCell.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/22/23.
//

import UIKit

class NewsFeedMediaSupportTableViewCell:UITableViewCell {
    let titleLabel: UILabel
    let containerView: UIView
    let locationLabel: UILabel
    let userNameLabel: UILabel
    let timestampLabel: UILabel
    let descriptionLabel: UILabel
    let commentCountLabel: UILabel
    let profileImageView: UIImageView
    var mediaCarouselView: MediaCarouselView?
    
    static let identifier = "NewsFeedMediaSupportTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        titleLabel = UILabel()
        containerView = UIView()
        locationLabel = UILabel()
        userNameLabel = UILabel()
        timestampLabel = UILabel()
        descriptionLabel = UILabel()
        commentCountLabel = UILabel()
        profileImageView = UIImageView(frame: .zero)
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
    
    func configure(_ newsFeed: NewsFeedData) {
        // Configure user name
        if let user = newsFeed.user {
            userNameLabel.text = user.name
        }
        
        // Configure title
        if let title = newsFeed.title {
            titleLabel.text = title
        }
        
        // Configure description
        if let description = newsFeed.newsFeedDescription {
            descriptionLabel.text = description
        }
        
        // Configure timestamp
        if let timestamp = newsFeed.createdAt,
           let dateToDisplay = timestamp.getDateString() {
            timestampLabel.text = dateToDisplay
        }
        
        // Configure profile image view
        if let profileURL = newsFeed.user?.profilePictureURL,
           let url = URL(string: profileURL) {
            profileImageView.sd_setImage(with: url)
        }
        
        
        // Configure comment count
        if let count = newsFeed.commentCount {
            commentCountLabel.text = count > 1 ? "\(count) comments" : "\(count) comment"
        }
        
        // Configure multiMedia items if there are any
        if !newsFeed.multiMedia.toArray().isEmpty {
            var mediaURLs = [String]()
            for item in newsFeed.multiMedia.toArray() {
                if let url = item.url {
                    mediaURLs.append(url)
                }
            }
            
            mediaCarouselView = MediaCarouselView(imageURLs: mediaURLs)
            if let mediaCarouselView = mediaCarouselView {
                containerView.addSubview(mediaCarouselView)
                mediaCarouselView.snp.makeConstraints { make in
                    make.height.equalTo(375)
                    make.left.right.equalToSuperview()
                    make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
                }
                
                containerView.addSubview(commentCountLabel)
                commentCountLabel.snp.remakeConstraints { make in
                    make.trailing.equalToSuperview().offset(-8)
                    make.bottom.equalToSuperview().offset(-20)
                    make.top.equalTo(mediaCarouselView.snp.bottom).offset(8)
                }
            }
        }
    }
    
    /// Set up UI
    private func setupUI() {
        contentView.backgroundColor = .cellBackgroundColor
        containerView.backgroundColor = .containerBackgroundColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 30
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.backgroundColor = .profileBackgroundColor
        containerView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
        }
        
        userNameLabel.numberOfLines = 0
        userNameLabel.font = .titleFont
        containerView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalTo(profileImageView.snp.top).offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        timestampLabel.numberOfLines = 0
        timestampLabel.font = .overline
        containerView.addSubview(timestampLabel)
        timestampLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.font = .titleFont
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
        }
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .descriptionFont
        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        commentCountLabel.numberOfLines = 0
        commentCountLabel.font = .descriptionFont
        commentCountLabel.text = "0 comments"
        containerView.addSubview(commentCountLabel)
        commentCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-20)
            if let mediaCarouselView = mediaCarouselView {
                make.top.equalTo(mediaCarouselView.snp.bottom).offset(8)
            } else {
                make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            }
        }
    }
    
    /// Reset data
    private func reset() {
        titleLabel.text = nil
        userNameLabel.text = nil
        locationLabel.text = nil
        timestampLabel.text = nil
        descriptionLabel.text = nil
        commentCountLabel.text = nil
        profileImageView.image = nil
        mediaCarouselView?.imageURLs = []
        mediaCarouselView?.collectionView.reloadData()
    }
}
