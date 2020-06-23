//
//  AppDelegate.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/23/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Constant
    
    // MARK: Variable
    var window: UIWindow?
    
    // MARK: Function
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13, *) {
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            let navigationController = UINavigationController(rootViewController: HomeVC())
            let navBar = navigationController.navigationBar
            navBar.shadowImage = UIImage()
            navBar.barTintColor = UIColor.App.jellyBean
            navBar.isTranslucent = false
            navBar.backIndicatorImage = R.image.arrow_left()
            navBar.backIndicatorTransitionMaskImage = R.image.arrow_left()
            navBar.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.fontWithProperties(name: .avenir, style: .heavy, size: 18) ?? .systemFont(ofSize: 18, weight: .heavy),
            ]
            navigationController.navigationBar.tintColor = .white
            
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
        
        configureDependencies()
        return true
    }
    
    func configureDependencies() {
        configureIQKeyboardManager()
    }
    
    func configureIQKeyboardManager() {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().toolbarTintColor = UIColor.App.jellyBean
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }
}

