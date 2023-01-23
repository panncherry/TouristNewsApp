//
//  CustomViewProviding.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import UIKit

/// Protocol to set up custom view which will be used in viewControllers
/// Custom view must be initialized in loadView cycle before used.
public protocol CustomViewProviding {
    associatedtype CustomView: UIView
}

extension CustomViewProviding where Self: UIViewController {
    public var customView: CustomView {
        guard let customView = view as? CustomView else {
            fatalError("Expected view to be of type \(CustomView.self) but got \(type(of: view)) instead")
        }
        return customView
    }
}
