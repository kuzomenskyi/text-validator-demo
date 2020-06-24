//
//  HomeVC.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/23/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController, TextValidator, IAlertHelper {
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
    
    var validationDropDownButtonDataSource = [ContentType]() {
        didSet {
            validationDropDownButton.dataSource = validationDropDownButtonDataSource
        }
    }
    
    var selectedContentType: ContentType?
    var successMessage = Message(message: Constants.validTextAlertMessage, image: R.image.successArrow(), color: UIColor.App.brightTurquoise)
    
    var isSuccessMessageHidden: Bool {
        get {
            return messageView.isHidden
        }
        set(needsToHide) {
            messageView.isHidden = needsToHide
            let newAlpha: CGFloat = needsToHide ? 0 : 1
            messageView.alpha = newAlpha
        }
    }
    
    lazy var dropDownButtons = [validationDropDownButton]
    
    lazy var dropDownMenuButtons: [DropDownMenuButton] = [
        DropDownMenuButton(anchorView: validationContainerView, dropDownMenuDelegate: self)
    ]
    
    lazy var messageView: MessageView = {
        let messageView = MessageView(withMessage: successMessage)
        return messageView
    }()
    
    // MARK: Outlet
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var validationTextField: TextField!
    @IBOutlet var validationContainerView: UIView!
    @IBOutlet var contentTypeTextField: TextField!
    @IBOutlet var validationDropDownButton: DropDownButton!
    @IBOutlet var submitButton: UIButton!
    
    // MARK: View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Constants.homeVCNavigationItemTitle
        view.backgroundColor = .white
        imageView.kf.setImage(with: URL.App.placeholderImageURL, options: [.transition(.fade(0.5))])
        contentTypeTextField.isUserInteractionEnabled = false
        configureValidationDropDownButton()
        configureValidationContainerView()
        configureDropDownButtons()
        configureMessageView()
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
        validationTextField.validationRules = selectedContentType?.rules
        guard let validationText = validationTextField.text, validationText.count > 0 else {
            let error = CustomError(title: "", description: Constants.emptyValidationTextErrorDescription, code: -1)
            presentErrorAlert(error); return
        }
        
        guard let validationRules = validationTextField.validationRules else {
            let error = CustomError(title: "", description: Constants.contentTypeIsNotSelectedErrorDescription, code: -1)
            presentErrorAlert(error); return
        }
        var validationError: Error?
        
        validate(validationTextField.text, textFieldName: "Text", withRules: validationRules, completion: { (error) in
            validationError = error
        })
        
        if let validationError = validationError {
            presentErrorAlert(validationError)
        } else {
            guard isSuccessMessageHidden else { return }
            UIView.animate(withDuration: 1.5, delay: 0, options: [.autoreverse], animations: { [weak self] in
                self?.isSuccessMessageHidden = false
                }, completion: { [weak self] _ in
                    self?.isSuccessMessageHidden = true
            })
        }

        #warning("Display alert if text field content type is nil")
    }
    
    // MARK: Function
    func configureValidationDropDownButton() {
        validationDropDownButtonDataSource = [
            ContentType(name: ContentType.Name.none.rawValue.capitalized, imageURL: URL.App.placeholderImageURL),
        ContentType(name: ContentType.Name.username.rawValue.capitalized, rules: ValidationRules(minLength: 4, maxLength: 20, areSpaceSymbolsConsidered: true, mustContainOnlyLetters: true), imageURL: URL.App.userProfileImageURL),
        ContentType(name: ContentType.Name.age.rawValue.capitalized, rules: ValidationRules(minLength: 1, maxLength: 3, areSpaceSymbolsConsidered: false, mustContainOnlyNumbers: true), imageURL: URL.App.ageImageURL),
        ContentType(name: ContentType.Name.password.rawValue.capitalized, rules: ValidationRules(minLength: 6, maxLength: 20, areSpaceSymbolsConsidered: true, requiresBothUppercaseAndLowercase: true, requiresAtLeastOneNumberAndCharacter: true), imageURL: URL.App.passwordImageURL)
        ]
    }
    
    func configureValidationContainerView() {
        validationContainerView.clipsToBounds = true
        validationContainerView.layer.cornerRadius = 10
        validationContainerView.backgroundColor = UIColor.App.athensGray
    }
    
    func configureDropDownButtons() {
        for button in dropDownButtons.enumerated() {
            button.element?.dropDownTableView?.backgroundColor = .lightText
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
    
    func configureMessageView() {
        isSuccessMessageHidden = true
        
        view.addSubview(messageView)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.2),
            messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width * 0.2),
            messageView.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -20),
            messageView.heightAnchor.constraint(equalTo: submitButton.heightAnchor, multiplier: 0.6)
        ])
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
            
            selectedContentType = contentType
            contentTypeTextField.text = output
            imageView.kf.setImage(with: contentType.imageURL, options: [.transition(.fade(0.5))])
            if validationTextField.isSecureTextEntry {
                validationTextField.text = ""
            }
            validationTextField.isSecureTextEntry = contentType.name.lowercased() == ContentType.Name.password.rawValue.lowercased()
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
