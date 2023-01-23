//
//  MediaCarouselViewCollectionViewCell.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import UIKit
import SDWebImage

/// MediaCarouselView CollectionViewCell
class MediaCarouselViewCollectionViewCell: UICollectionViewCell {
    var imageURL: String?
    let imageView: UIImageView
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: frame)
        super.init(frame: frame)
        backgroundColor = .black
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0,
                                 width: contentView.frame.size.width,
                                 height: contentView.frame.size.height)
    }
    
    /// Load images in imageView
    func loadImage() {
        // Prevents this from firing multiple times.  We nil the image out in prepareForReuse.
        guard imageView.image == nil else {
            return
        }

        if let imageURLString = imageURL,
           let imageURL = URL(string: imageURLString) {
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeHolderImage"))
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageURL = nil
        imageView.image = nil
    }
}
