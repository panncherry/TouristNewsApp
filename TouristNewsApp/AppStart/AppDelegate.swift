//
//  AppDelegate.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        // Set up root view controller
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = MainTabbarViewController()
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
}
