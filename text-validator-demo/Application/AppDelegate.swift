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
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeScreen = HomeVC(nibName: R.nib.homeVC.name, bundle: R.nib.homeVC.bundle)
        let navigationController = UINavigationController(rootViewController: homeScreen)

        configureNavBar()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        configureDependencies()
        return true
    }
    
    // MARK: Private function
    private func configureDependencies() {
        configureIQKeyboardManager()
    }
    
    private func configureIQKeyboardManager() {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().toolbarTintColor = UIColor.App.jellyBean
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }
    
    private func configureNavBar() {
        let appearance = UINavigationBar.appearance()
        appearance.shadowImage = UIImage()
        appearance.barTintColor = UIColor.App.jellyBean
        appearance.backIndicatorImage = R.image.arrow_left()
        appearance.backIndicatorTransitionMaskImage = R.image.arrow_left()
        appearance.tintColor = .white
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.fontWithProperties(name: .avenir, style: .heavy, size: 18) ?? .systemFont(ofSize: 18, weight: .heavy),
        ]
        
        if #available(iOS 13, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.App.jellyBean
            appearance.titleTextAttributes = appearance.titleTextAttributes
            appearance.shadowColor = nil
            
            UINavigationBar.appearance().isTranslucent = true
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
        }
    }
}

