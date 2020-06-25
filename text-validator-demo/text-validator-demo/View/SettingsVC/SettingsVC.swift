//
//  SettingsVC.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/24/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    // MARK: Constant
    
    // MARK: Variable
    
    // MARK: Outlet
    @IBOutlet var containerView: UIView!
    @IBOutlet var searchContainerView: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    // MARK: View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Constants.settingsVCNavigationItemTitle
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        containerView.backgroundColor = UIColor.App.jellyBean
        searchBar.layer.borderWidth = 0
        searchBar.backgroundImage = UIImage()
        searchBar.setTextFieldColor(color: .white)
    }
    
    // MARK: Init
    
    // MARK: Action
    
    // MARK: Function
}

// MARK: - UITableViewDelegate
extension SettingsVC: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension SettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        #warning("Configure")
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        #warning("Configure")
        return UITableViewCell()
    }
    
}
