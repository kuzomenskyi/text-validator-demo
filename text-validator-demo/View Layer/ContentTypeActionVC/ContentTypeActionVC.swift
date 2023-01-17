//
//  ContentTypeActionVC.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/26/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit
import SnapKit

final class ContentTypeActionVC: UIViewController {
    enum ScreenType {
        case addContentTyoe, editContentType
    }
    
    // MARK: Constant
    
    // MARK: Variable
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Private Variable
    private var screenType: ScreenType = .addContentTyoe
    private var contentTypeToEdit: ContentType?
    
    private lazy var contentTypesView: ContentTypesView = {
        let view = ContentTypesView()
        return view
    }()
    
    // MARK: View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: Init
    init(contentTypeToEdit: ContentType? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.contentTypeToEdit = contentTypeToEdit
        if contentTypeToEdit != nil {
            screenType = .editContentType
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Action
    
    // MARK: Function
    
    // MARK: Privat function
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationItem()
        setContentTypesView()
    }
    
    private func configureNavigationItem() {
        if screenType == .addContentTyoe {
            navigationItem.title = Constants.contentTypeActionAddVCTitle
        } else {
            navigationItem.title = contentTypeToEdit?.name ?? Constants.contentTypeActionEditVCTitle
        }
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setContentTypesView() {
        view.addSubview(contentTypesView)
        contentTypesView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
