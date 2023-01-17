//
//  UINavigationController+StatusBar.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/5/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

extension UINavigationController {
    override open var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}
