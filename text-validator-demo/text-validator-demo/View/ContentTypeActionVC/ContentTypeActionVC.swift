//
//  ContentTypeActionVC.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/26/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

class ContentTypeActionVC: UIViewController {
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
