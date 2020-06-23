//
//  HomeVC.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/23/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    // MARK: Constant
    
    // MARK: Variable
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Outlet
    
    // MARK: View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: Init
    
    // MARK: Action
    
    // MARK: Function

}
