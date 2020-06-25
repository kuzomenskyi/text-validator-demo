//
//  ContentTypesListVC.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/24/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

class ContentTypesListVC: UIViewController {
    // MARK: Constant
    let tableViewRowHeight: CGFloat = 60
    
    // MARK: Variable
    lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: R.image.plus(), style: .plain, target: self, action: #selector(plusEvent))
        button.tintColor = .white
        return button
    }()
    
    var contentTypes = [ContentType]()
    
    // MARK: Outlet
    @IBOutlet var containerView: UIView!
    @IBOutlet var searchContainerView: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    // MARK: View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureSearchBar()
        configureTableView()
        containerView.backgroundColor = UIColor.App.jellyBean
    }
    
    // MARK: Init
    init(contentTypes: [ContentType]? = nil, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.contentTypes = contentTypes ?? [ContentType]()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Action
    @objc func plusEvent() {
        print("plusEvent")
    }
    
    // MARK: Function
    func configureNavigationItem() {
        navigationItem.title = Constants.contentTypesListVCNavigationItemTitle
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.setRightBarButton(plusButton, animated: false)
    }
    
    func configureSearchBar() {
        searchBar.layer.borderWidth = 0
        searchBar.backgroundImage = UIImage()
        searchBar.setTextFieldColor(color: .white)
        #warning("Continue configuration")
    }
    
    func configureTableView() {
        tableView.delegate = self; tableView.dataSource = self
        tableView.register(UINib(nibName: R.nib.contentTypeListCell.name, bundle: R.nib.contentTypeListCell.bundle), forCellReuseIdentifier: R.reuseIdentifier.contentTypeListCell.identifier)
        let removeAdditionalSeparators = { [unowned self] in self.tableView.tableFooterView = UIView() }
        removeAdditionalSeparators()
    }
}

// MARK: - UITableViewDelegate
extension ContentTypesListVC: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension ContentTypesListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.contentTypeListCell, for: indexPath) as? ConfigurableCell else {
            let output = UITableViewCell()
            output.backgroundColor = .red
            return output
        }
        
        cell.configure(withAny: contentTypes[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
}
