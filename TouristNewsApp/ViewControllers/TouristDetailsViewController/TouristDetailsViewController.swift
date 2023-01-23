//
//  TouristDetailsViewController.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import UIKit

class TouristDetailsViewController: UIViewController, CustomViewProviding {
    
    typealias CustomView = TouristDetailsView
    
    var tourist: TouristData
    
    init(_ data: TouristData) {
        tourist = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = TouristDetailsView(tourist: tourist)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tourist Details"
        view.backgroundColor = .cellBackgroundColor
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let backImage = UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysTemplate)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationController?.navigationBar.tintColor = .label
    }
    
}
