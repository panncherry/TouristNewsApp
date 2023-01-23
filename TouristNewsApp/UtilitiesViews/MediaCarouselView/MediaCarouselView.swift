//
//  MediaCarouselView.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import UIKit
import SnapKit

/// Media Carousel View
class MediaCarouselView: UIView {
    
    var imageURLs: [String] 
    let pageControl: UIPageControl
    let numberOfImagesLabel: UILabel
    let collectionView: UICollectionView
    let layout: UICollectionViewFlowLayout
    var photoFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    weak var delegate: MediaCarouselViewDelegate?
    
    let reuseIdentifier = "MediaCarouselViewCollectionViewCell"
    
    private var numImages: Int {
        return imageURLs.count == 0 ? 1 : imageURLs.count
    }
    
    init(imageURLs: [String]) {
        self.imageURLs = imageURLs
        pageControl = UIPageControl()
        numberOfImagesLabel = UILabel()
        
        layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 375)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 375), collectionViewLayout: layout)
        super.init(frame: .zero)
        
        collectionView.register(MediaCarouselViewCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        pageControl.backgroundColor = .clear
        pageControl.numberOfPages = numImages
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.4)
        addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.height.equalTo(8)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.bottom).offset(-20)
        }
        
        numberOfImagesLabel.layer.cornerRadius = 6
        numberOfImagesLabel.text = " 1/\(numImages) "
        numberOfImagesLabel.layer.masksToBounds = true
        numberOfImagesLabel.textColor = .white
        numberOfImagesLabel.font = .overline
        numberOfImagesLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addSubview(numberOfImagesLabel)
        numberOfImagesLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout.itemSize = frame.size
    }
    
    
    func updatePageControls() {
        let pageIndex = round(collectionView.contentOffset.x/collectionView.frame.size.width)
        pageControl.currentPage = Int(pageIndex)
        numberOfImagesLabel.text = " \(Int(pageIndex+1))/\(numImages) "
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageControls()
    }
    
}


// MARK: - UICollectionView Delegate, UICollectionView DataSource
extension MediaCarouselView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MediaCarouselViewCollectionViewCell
        collectionViewCell.imageURL = imageURLs[indexPath.row]
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let collectionViewCell = cell as? MediaCarouselViewCollectionViewCell {
            collectionViewCell.loadImage()
        }
    }
    
}
