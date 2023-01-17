//
//  HomeVC.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/23/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

final class HomeVC: UIViewController, TextValidator, IAlertHelper, DefaultsManager {
    // MARK: Constant
    let dropDownMenuRowHeight: CGFloat = 50
    
    // MARK: Variable
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // dropDownMenuHeight
    var expandedStateHeight: CGFloat = 150
    
    // MARK: Private Variable
    private var contentTypesRepository: IContentTypesRepository = ContentTypesRepository()
    private var contentTypesObserver: IContentTypesObserver = ContentTypesObserver()
    private var expandedDropDownMenuDataSource: [Any] { expandedMenuButton?.dataSource ?? [Any]() }
    
    private var expandedMenuButton: DropDownButton? {
        didSet {
            expandedMenuButton?.dropDownTableView?.reloadData()
            setDropDownMenu(isExpanded: false, except: expandedMenuButton)
        }
    }
    
    private var cellToDisplay: Cell? = Cell(identifier: R.reuseIdentifier.dropDownMenuCell.identifier)
    
    private var validationDropDownButtonDataSource = [ContentType]() {
        didSet {
            validationDropDownButton.dataSource = validationDropDownButtonDataSource
            DispatchQueue.main.async { [weak self] in
                self?.validationDropDownButton.dropDownTableView?.reloadData()
            }
        }
    }
    
    private var selectedContentType: ContentType?
    private var successMessage = Message(message: Constants.validTextAlertMessage, image: R.image.successArrow(), color: UIColor.App.brightTurquoise)
    
    private var contentTypes: [ContentType] {
        get {
            return contentTypesRepository.getContentTypes()
        }
        set(newTypes) {
            newTypes.forEach { contentTypesRepository.insert(contentType: $0) }
            validationDropDownButtonDataSource = newTypes
        }
    }
    
    private var contentTypeNeedsUpdateIndexPath: IndexPath?
    
    private var isSuccessMessageHidden: Bool {
        get {
            return messageView.isHidden
        }
        set(needsToHide) {
            messageView.isHidden = needsToHide
            let newAlpha: CGFloat = needsToHide ? 0 : 1
            messageView.alpha = newAlpha
        }
    }
    
    private var isDropDownButtonTableViewUpdateNeeded = false
    
    private lazy var dropDownButtons = [validationDropDownButton]
    
    private lazy var dropDownMenuButtons: [DropDownMenuButtonSettings] = [
        DropDownMenuButtonSettings(anchorView: validationContainerView, dropDownMenuDelegate: self)
    ]
    
    private lazy var messageView: MessageView = {
        let messageView = MessageView(withMessage: successMessage)
        return messageView
    }()
    
    private lazy var settingsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: R.image.settings(), style: .plain, target: self, action: #selector(settingsEvent))
        button.tintColor = .white
        return button
    }()
    
    // MARK: Outlet
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var validationTextField: TextField!
    @IBOutlet private var validationContainerView: UIView!
    @IBOutlet private var contentTypeTextField: TextField!
    @IBOutlet private var validationDropDownButton: DropDownButton!
    @IBOutlet private var submitButton: UIButton!
    
    // MARK: View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Constants.homeVCTitle
        navigationItem.setRightBarButton(settingsButton, animated: false)
        view.backgroundColor = .white
        imageView.image = UIImage.placeholderImage
        contentTypeTextField.isUserInteractionEnabled = false
        if getDefaultsValue(forKey: Constants.kIsContentTypeTemplatesAdded) as? Bool ?? false == false {
            addContentTypeTemplates()
        }
        configureValidationContainerView()
        configureDropDownButtons()
        configureMessageView()
        let textFields = [contentTypeTextField, validationTextField]
        textFields.forEach { $0?.insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0) }
        
        contentTypesObserver.observeForDatabaseContentUpdate { [weak self] (notification) in
            guard let self = self else { return }
            if let userInfo = notification.userInfo, let editedContentTypeName = userInfo[Constants.kContentTypeName], let stringTypeName = editedContentTypeName as? String {
                
                if self.contentTypeTextField.text?.lowercased() == stringTypeName.lowercased() {
                    self.contentTypeNeedsUpdateIndexPath = IndexPath(row: 0, section: 0)
                }
            }
            self.isDropDownButtonTableViewUpdateNeeded = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        updateDropDownButtonIfNeeded()
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
    }
    
    @objc func settingsEvent() {
        let contentTypesListVC = ContentTypesListVC(contentTypesRepository: contentTypesRepository, nibName: R.nib.contentTypesListVC.name, bundle: R.nib.contentTypesListVC.bundle)
        navigationController?.pushViewController(contentTypesListVC, animated: true)
    }
    
    // MARK: Function
    
    // MARK: Private function
    private func addContentTypeTemplates() {
        contentTypes = [
            ContentType(name: ContentType.Name.none.rawValue.capitalized, imageFile: UIImage.placeholderImage.getBase64DecodedData() ?? nil),
            ContentType(name: ContentType.Name.username.rawValue.capitalized, rules: ValidationRules(minLength: 4, maxLength: 20, areSpaceSymbolsConsidered: true, mustContainOnlyLetters: true), imageFile: UIImage.userProfileImage.getBase64DecodedData() ?? nil),
            ContentType(name: ContentType.Name.age.rawValue.capitalized, rules: ValidationRules(minLength: 1, maxLength: 3, areSpaceSymbolsConsidered: false, mustContainOnlyNumbers: true), imageFile: UIImage.ageImage.getBase64DecodedData() ?? nil),
            ContentType(name: ContentType.Name.password.rawValue.capitalized, rules: ValidationRules(minLength: 6, maxLength: 20, areSpaceSymbolsConsidered: true, requiresBothUppercaseAndLowercase: true, requiresAtLeastOneNumberAndCharacter: true), imageFile: UIImage.passwordImage.getBase64DecodedData() ?? nil)
        ]
        
        setDefaultsValue(true, forKey: Constants.kIsContentTypeTemplatesAdded)
    }
    
    private func configureValidationContainerView() {
        validationContainerView.clipsToBounds = true
        validationContainerView.layer.cornerRadius = 10
        validationContainerView.backgroundColor = UIColor.App.athensGray
    }
    
    private func configureDropDownButtons() {
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
        updateDropDownButtonContent()
    }
    
    private func setDropDownTableViewsScrolling(isEnabled: Bool, except exception: DropDownButton? = nil) {
        exception?.dropDownTableView?.isScrollEnabled = !isEnabled
        let otherDropDownButtons = dropDownButtons.filter { $0 != exception }
        otherDropDownButtons.forEach { $0?.dropDownTableView?.isScrollEnabled = isEnabled }
    }
    
    private func setDropDownMenu(isExpanded: Bool, except exception: DropDownButton? = nil) {
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
    
    private func configureMessageView() {
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
    
    private func updateDropDownButtonContent() {
        validationDropDownButtonDataSource = contentTypes
        
        DispatchQueue.main.async { [weak self] in
            self?.validationDropDownButton.dropDownTableView?.reloadData()
        }
    }
    
    private func updateDropDownButtonIfNeeded() {
        if isDropDownButtonTableViewUpdateNeeded {
            updateDropDownButtonContent()
            isDropDownButtonTableViewUpdateNeeded = false
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if self.validationDropDownButton.isExpanded {
                    self.validationDropDownButton.shortenDropDownMenu()
                }
            }
        }
        if let contentTypeNeedsUpdateIndexPath = contentTypeNeedsUpdateIndexPath, let validationDropDownButton = self.validationDropDownButton.dropDownTableView {
            tableView(validationDropDownButton, didSelectRowAt: contentTypeNeedsUpdateIndexPath)
            self.contentTypeNeedsUpdateIndexPath = nil
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
        let isIndexValid = !expandedDropDownMenuDataSource.isEmpty && expandedDropDownMenuDataSource.count - 1 >= indexPath.row
        guard isIndexValid else { return }
        let selectedValue = expandedDropDownMenuDataSource[indexPath.row]
        
        #warning("Refactor that to conform the OCP")
        if expandedMenuButton == validationDropDownButton, let contentType = selectedValue as? ContentType {
            var output = ""
            
            if contentType.name.lowercased() != ContentType.Name.none.rawValue.lowercased() {
                output = contentType.name
            }
            
            selectedContentType = contentType
            contentTypeTextField.text = output
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = contentType.image
            }
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
