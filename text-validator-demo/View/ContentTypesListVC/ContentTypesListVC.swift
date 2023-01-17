//
//  ContentTypesListVC.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/24/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

final class ContentTypesListVC: UIViewController, IAlertHelper, TextValidator {
    // MARK: Constant
    let tableViewRowHeight: CGFloat = 75
    
    // MARK: Variable
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var contentTypesRepository: IContentTypesRepository?
    
    var contentTypes = [ContentType]()
    
    var filteredContentTypes = [ContentType]() {
        didSet {
            updateTableView()
        }
    }
    
    var isSearching = false {
        didSet {
            updateTableView()
        }
    }
    
    var isContentTypeWasRemoved: Bool = false
    
    lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: R.image.plus(), style: .plain, target: self, action: #selector(plusEvent))
        button.tintColor = .white
        return button
    }()
    
    var dataSource: [ContentType] {
        get {
            return isSearching ? filteredContentTypes : contentTypes
        }
        set {
            let changeProducts = { [weak self] in
                self?.contentTypes = newValue
            }
            let changeFilteredProducts = { [weak self] in
                self?.filteredContentTypes = newValue
            }
            
            isSearching ? changeProducts() : changeFilteredProducts()
        }
    }
    
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
        contentTypes = contentTypesRepository?.getContentTypes() ?? [ContentType]()
        removeContentType(withName: "None")
        updateTableView()
    }
    
    // MARK: Init
    init(contentTypesRepository: IContentTypesRepository?, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.contentTypesRepository = contentTypesRepository
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Action
    @objc func plusEvent() {
        var newType = ContentType(name: "Template \(Int.random(in: 0...9999999))")
        
        let image = UIImage.placeholderImage
        let imageData = image.pngData()
        let strBase64 = imageData?.base64EncodedString(options: .lineLength64Characters)
        
        newType.imageFile = strBase64 ?? nil
        
        
        contentTypesRepository?.insert(contentType: newType)
        contentTypes = contentTypesRepository?.getContentTypes() ?? [ContentType]()
        removeContentType(withName: "None")
        tableView.insertRows(at: [IndexPath(row: contentTypes.count - 1, section: 0)], with: .automatic)
        postProductUpdateNotification()
    }
    
    // MARK: Function
    func configureNavigationItem() {
        navigationItem.title = Constants.contentTypesListVCTitle
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.setRightBarButton(plusButton, animated: false)
    }
    
    func configureSearchBar() {
        searchBar.layer.borderWidth = 0
        searchBar.backgroundImage = UIImage()
        searchBar.setTextFieldColor(color: .white)
        searchBar.delegate = self
    }
    
    func configureTableView() {
        tableView.delegate = self; tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: R.nib.contentTypeListCell.name, bundle: R.nib.contentTypeListCell.bundle), forCellReuseIdentifier: R.reuseIdentifier.contentTypeListCell.identifier)
        let removeAdditionalSeparators = { [unowned self] in self.tableView.tableFooterView = UIView() }
        removeAdditionalSeparators()
    }
    
    func deleteContentType(withIndexPath indexPath: IndexPath) -> Bool {
        let contentTypeToDelete = dataSource[indexPath.row]
        var output = false
        
        let yesAction = Action(title: "Yes", style: .destructive, handler: { [weak self] in
            guard let self = self else { return }
            self.isContentTypeWasRemoved = true
            self.contentTypes.remove(at: indexPath.row)
            self.contentTypesRepository?.delete(contentTypeWithName: contentTypeToDelete.name)
            DispatchQueue.main.async {
                self.deleteTableViewRows(at: [indexPath])
            }
            self.postProductUpdateNotification(contentTypeToDelete)
            output = true
        })
        
        let cancelAction = Action(title: Constants.cancelActionTitle, style: .cancel, handler: nil)
        presentAlert(title: "Content type deletion", message: "Are you sure?", actions: [yesAction, cancelAction], completion: nil)

        return output
    }
    
    func startSearchEvent(searchBar: UISearchBar, searchText: String) {
        guard isSearchTextValid(searchText) else { return }
        
        filteredContentTypes = contentTypes.filter {
            let nameComponents = $0.name.components(separatedBy: " ")
            var output = false
            
            for nameComponent in nameComponents {
                if nameComponent.prefix(searchText.count).lowercased() == searchText.lowercased() {
                    output = true
                }
            }
            return output
        }
    }
    
    func stopSearchEvent() {
        
    }
    
    func updateTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func deleteTableViewRows(at indexPaths: [IndexPath]) {
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func reloadTableViewRows(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }
    
    func dataSourceChangedEvent() {
        #warning("update no content types message visibility here")
        if !isContentTypeWasRemoved {
            updateTableView()
        }
        isContentTypeWasRemoved = false
    }
    
    func postProductUpdateNotification(_ contentType: ContentType? = nil) {
        let userInfo: [AnyHashable: Any]? = [Constants.kContentTypeName: contentType?.name ?? ""]
        NotificationCenter.default.post(name: Notification.Name.App.databaseContentUpdateNotification, object: nil, userInfo: userInfo)
    }
    
    // MARK: - Private Function
    private func removeContentType(withName name: String) {
        contentTypes = contentTypes.filter { $0.name != name }
        filteredContentTypes = filteredContentTypes.filter { $0.name != name }
    }
    
    private func isSearchTextValid(_ searchText: String) -> Bool {
        let validationRules = ValidationRules(minLength: 1, areSpaceSymbolsConsidered: false)
        var output = true
        
        validate(searchText, textFieldName: nil, withRules: validationRules, completion: { error in
            if error != nil {
                output = false
            }
        })
        
        return output
    }
}

// MARK: - UITableViewDelegate
extension ContentTypesListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = dataSource[indexPath.row]
        let contentTypeActionVC = ContentTypeActionVC(contentTypeToEdit: type, nibName: R.nib.contentTypeActionVC.name, bundle: R.nib.contentTypeActionVC.bundle)
        navigationController?.pushViewController(contentTypeActionVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            
            let isResultSuccessful = self.deleteContentType(withIndexPath: indexPath)
            completion(isResultSuccessful)
        }

        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = true
        return swipeActionConfig
    }
}

// MARK: - UITableViewDataSource
extension ContentTypesListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.contentTypeListCell, for: indexPath) as? ConfigurableCell else {
            let output = UITableViewCell()
            output.backgroundColor = .red
            return output
        }
        
        cell.configure(withAny: dataSource[indexPath.row])
        cell.selectionStyle = .none
        
        if let completionableCell = cell as? Completionable {
            completionableCell.setCellCompletion(completion: { [weak self] cell in
                guard let selectedCellIndexPath = tableView.indexPath(for: cell) else { return }
                self?.tableView(tableView, didSelectRowAt: selectedCellIndexPath)
            })
        }
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension ContentTypesListVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            isSearching = true
            startSearchEvent(searchBar: searchBar, searchText: searchText)
        } else {
            isSearching = false
            stopSearchEvent()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(false)
    }
}
