//
//  ContentTypeListCell.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/25/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

final class ContentTypeListCell: UITableViewCell {
    // MARK: Constant
    
    // MARK: Variable
    var cellCompletion: CellCompletion?
    
    // MARK: Outlet
    @IBOutlet private var contentTypeImageView: UIImageView!
    @IBOutlet private var contentTypeNameLabel: UILabel!
    @IBOutlet private var editButton: UIButton!
    
    // MARK: Init
    
    // MARK: Action
    @IBAction func editEvent(_ sender: Any) {
        cellCompletion?(self)
    }
    
    // MARK: Function
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    // MARK: Private Function
    private func configureUI() {
        editButton.tintColor = UIColor.App.jellyBean
    }
    
    private func configure(withContentType contentType: ContentType) {
        contentTypeImageView.image = contentType.image
        contentTypeNameLabel.text = contentType.name
    }
}

extension ContentTypeListCell: ConfigurableCell {
    func configure(withAny input: Any) {
        if let contentType = input as? ContentType {
            configure(withContentType: contentType)
        }
    }
}

extension ContentTypeListCell: Completionable {
    func setCellCompletion(completion: CellCompletion?) {
        cellCompletion = completion
    }
}
