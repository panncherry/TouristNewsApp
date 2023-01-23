//
//  MediaCarouselViewDelegate.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import UIKit

protocol MediaCarouselViewDelegate: AnyObject {
    func mediaCarouselViewImageSelected(imageURL: String)
}
