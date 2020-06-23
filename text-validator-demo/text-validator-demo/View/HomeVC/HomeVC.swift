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
    let dropDownMenuRowHeight: CGFloat = 50
    
    // MARK: Variable
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var expandedDropDownMenuDataSource: [Any] { expandedMenuButton?.dataSource ?? [Any]() }
    
    var expandedMenuButton: DropDownButton? {
        didSet {
            expandedMenuButton?.dropDownTableView?.reloadData()
            setDropDownMenu(isExpanded: false, except: expandedMenuButton)
        }
    }
    
    var cellToDisplay: Cell? = Cell(identifier: R.reuseIdentifier.dropDownMenuCell.identifier)
    // dropDownMenuHeight
    var expandedStateHeight: CGFloat = 150
    
    lazy var dropDownButtons = [validationDropDownButton]
    
    lazy var dropDownMenuButtons: [DropDownMenuButton] = [
        DropDownMenuButton(anchorView: validationContainerView, dropDownMenuDelegate: self)
    ]
    
    // MARK: Outlet
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var validationTextField: TextField!
    @IBOutlet var validationContainerView: UIView!
    @IBOutlet var contentTypeTextField: TextField!
    @IBOutlet var validationDropDownButton: DropDownButton!
    @IBOutlet var submitButton: UIButton!
    
    // MARK: View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        validationDropDownButton.dataSource = [
            ContentType(name: ContentType.Name.none.rawValue.capitalized),
            ContentType(name: ContentType.Name.username.rawValue.capitalized),
            ContentType(name: ContentType.Name.age.rawValue.capitalized),
            ContentType(name: ContentType.Name.password.rawValue.capitalized)
        ]
        contentTypeTextField.isUserInteractionEnabled = false
        
        configureValidationContainerView()
        configureDropDownButtons()
        let textFields = [contentTypeTextField, validationTextField]
        textFields.forEach { $0?.insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: Init
    
    // MARK: Action
    @IBAction func validationDropDownEvent(_ sender: Any) {
        !validationDropDownButton.isExpanded ? validationDropDownButton.expandDropDownMenu() : validationDropDownButton.shortenDropDownMenu()
        expandedMenuButton = validationDropDownButton
    }
    
    @IBAction func submitEvent(_ sender: Any) {
        #warning("Configure event")
        // display alert if text field content type is nil
    }
    
    // MARK: Function
    func configureValidationContainerView() {
        validationContainerView.clipsToBounds = true
        validationContainerView.layer.cornerRadius = 10
        validationContainerView.backgroundColor = UIColor.App.athensGray
    }
    
    func configureDropDownButtons() {
        for button in dropDownButtons.enumerated() {
            button.element?.dropDownTableView?.backgroundColor = .systemGroupedBackground
            button.element?.dropDownMenuDelegate = dropDownMenuButtons[button.offset].dropDownMenuDelegate
            button.element?.anchorView = dropDownMenuButtons[button.offset].anchorView
            button.element?.dropDownTableView?.rowHeight = dropDownMenuRowHeight
            setDropDownTableViewsScrolling(isEnabled: true)
            assert(cellToDisplay != nil, "@@@@@ HomeVC's cellToDisplay is nil!")
            guard let cellToDisplay = cellToDisplay else { return }
            button.element?.dropDownTableView?.register(UINib(nibName: cellToDisplay.identifier, bundle: nil), forCellReuseIdentifier: cellToDisplay.identifier)
        }
    }
    
    func setDropDownTableViewsScrolling(isEnabled: Bool, except exception: DropDownButton? = nil) {
        exception?.dropDownTableView?.isScrollEnabled = !isEnabled
        let otherDropDownButtons = dropDownButtons.filter { $0 != exception }
        otherDropDownButtons.forEach { $0?.dropDownTableView?.isScrollEnabled = isEnabled }
    }
    
    func setDropDownMenu(isExpanded: Bool, except exception: DropDownButton? = nil) {
        let otherDropDownButtons = dropDownButtons.filter { $0 != exception }
        let needsToBeExpanded = isExpanded
        
        otherDropDownButtons.forEach {
            guard let menu = $0 else { return }
            if needsToBeExpanded {
                if !menu.isExpanded {
                    menu.expandDropDownMenu()
                }
            } else {
                if menu.isExpanded {
                    menu.shortenDropDownMenu()
                }
            }
        }
    }
}

// MARK: - DropDownMenuDelegate
extension HomeVC: DropDownMenuDelegate {
    var dropDownMenuTableViewDelegate: UITableViewDelegate? {
        return self
    }
    
    var dropDownMenuTableViewDataSource: UITableViewDataSource? {
        return self
    }
}

// MARK: - UITableViewDelegateResponse from
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedValue = expandedDropDownMenuDataSource[indexPath.row]
        
        #warning("Refactor that to conform the OCP")
        if expandedMenuButton == validationDropDownButton, let contentType = selectedValue as? ContentType {
            var output = ""
            
            if contentType.name.lowercased() != ContentType.Name.none.rawValue.lowercased() {
                output = contentType.name
            }
            
            contentTypeTextField.text = output
        }
        expandedMenuButton?.shortenDropDownMenu()
    }
}

// MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expandedDropDownMenuDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentCellID = cellToDisplay?.identifier, let cell = tableView.dequeueReusableCell(withIdentifier: currentCellID) as? ConfigurableCell else {
            let cell = UITableViewCell()
            cell.backgroundColor = .red
            print("@@@@@ Failed to deque cell with specified identifier for ProductActionVC's table view")
            return cell
        }
        
        cell.backgroundColor = UIColor.App.alto
        let isIndexValid = indexPath.row <= (expandedDropDownMenuDataSource.count - 1)
        guard !expandedDropDownMenuDataSource.isEmpty, isIndexValid else { return cell }
        cell.configure(withAny: expandedDropDownMenuDataSource[indexPath.row])
        return cell
    }
}
