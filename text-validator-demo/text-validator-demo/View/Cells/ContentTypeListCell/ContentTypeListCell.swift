//
//  ContentTypeListCell.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/25/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

class ContentTypeListCell: UITableViewCell {
    // MARK: Constant
    
    // MARK: Variable
    var cellCompletion: CellCompletion?
    
    // MARK: Outlet
    @IBOutlet var contentTypeImageView: UIImageView!
    @IBOutlet var contentTypeNameLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    
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
    
    func configureUI() {
        editButton.tintColor = UIColor.App.jellyBean
    }
    
    // MARK: Private Function
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
