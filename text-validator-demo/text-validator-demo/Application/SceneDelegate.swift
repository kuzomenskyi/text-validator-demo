//
//  SceneDelegate.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/23/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: Constant
    
    // MARK: Variable
    var window: UIWindow?
    
    // MARK: Function
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController(rootViewController: HomeVC())
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundEffect = .none
        navBarAppearance.backgroundImage = nil
        navBarAppearance.backgroundColor = UIColor.App.jellyBean
        navBarAppearance.shadowColor = .clear
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.setBackIndicatorImage(R.image.arrow_left(), transitionMaskImage: R.image.arrow_left())
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.fontWithProperties(name: .avenir, style: .heavy, size: 18) ?? .systemFont(ofSize: 18, weight: .heavy)
        ]
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.standardAppearance = navBarAppearance

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

