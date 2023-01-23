//
//  MainTabbarViewController.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import UIKit

class MainTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addTabbars()
    }
    
    private func addTabbars() {
        // NewsFeedViewController at tab index 0
        let tabOne = UINavigationController(rootViewController: NewsFeedViewController())
        let tabOneBarItem = UITabBarItem(title: "News Feed",
                                         image: UIImage(systemName: "newspaper"),
                                         selectedImage: UIImage(systemName: "newspaper.fill"))
        
        tabOne.tabBarItem = tabOneBarItem
        
        // TouristViewController at tab index 1
        let tabTwo = UINavigationController(rootViewController: TouristsViewController())
        let tabTwoBarItem2 = UITabBarItem(title: "Tourists",
                                          image: UIImage(systemName: "person.2"),
                                          selectedImage: UIImage(systemName: "person.2.fill"))
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
        // Add viewcontrollers to tabbar viewcontrollers
        viewControllers = [tabOne, tabTwo]
        tabBar.tintColor = .darkGray
    }
}
