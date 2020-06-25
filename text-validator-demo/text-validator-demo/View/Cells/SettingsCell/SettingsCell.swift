//
//  SettingsCell.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/25/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    // MARK: Constant
    
    // MARK: Variable
    
    // MARK: Outlet
    @IBOutlet var contentTypeImageView: UIImageView!
    @IBOutlet var contentTypeNameLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    
    // MARK: Init
    
    // MARK: Action
    @IBAction func editEvent(_ sender: Any) {
        print("editEvent")
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

extension SettingsCell: ConfigurableCell {
    func configure(withAny input: Any) {
        if let contentType = input as? ContentType {
            configure(withContentType: contentType)
        }
    }
}
