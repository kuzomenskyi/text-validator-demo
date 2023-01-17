//
//  ContentTypeActionVC.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/26/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit
import SnapKit

#warning("Configure UI with SnapKit")
// Edit name text field
// Change image button
// Rules:
// min length and max length slider
// areSpaceSymbolsConsidered switch
// areSpaceSymbolsConsidered info button
// banned symbols text field
// banned symbols info button
// white list symbols text field
// white list symbols info button
// requiresBothUppercaseAndLowercase switch
// requiresBothUppercaseAndLowercase info button
// requiresAtLeastOneNumberAndCharacter switch
// requiresAtLeastOneNumberAndCharacter info button
// exclusiveness picker view (letters, numbers)
// exclusiveness info button
// Save button
// Ask for confirmation if leaving the screen with changes not saved

final class ContentTypeActionVC: UIViewController {
    enum ScreenType {
        case addContentTyoe, editContentType
    }
    
    // MARK: Constant
    
    // MARK: Variable
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var screenType: ScreenType = .addContentTyoe
    var contentTypeToEdit: ContentType?
    
    // MARK: Outlet
    
    // MARK: View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
    }
    
    // MARK: Init
    init(contentTypeToEdit: ContentType? = nil, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.contentTypeToEdit = contentTypeToEdit
        if let contentTypeToEdit = contentTypeToEdit {
            screenType = .editContentType
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Action
    
    // MARK: Function
    func configureNavigationItem() {
        if screenType == .addContentTyoe {
            navigationItem.title = Constants.contentTypeActionAddVCTitle
        } else {
            navigationItem.title = contentTypeToEdit?.name ?? Constants.contentTypeActionEditVCTitle
        }
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
