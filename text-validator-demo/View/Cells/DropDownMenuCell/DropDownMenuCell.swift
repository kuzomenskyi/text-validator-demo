//
//  DropDownMenuCell.swift
//  Liquor Sales
//
//  Created by vladimir.kuzomenskyi on 5/29/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

final class DropDownMenuCell: UITableViewCell {
    // MARK: Constant
    
    // MARK: Variable
    
    // MARK: Outlet
    @IBOutlet var label: UILabel!
    
    // MARK: Init
    
    // MARK: Action
    
    // MARK: Private Function
    private func configure(withContentType contentType: ContentType) {
        label.text = contentType.name
    }
}

extension DropDownMenuCell: ConfigurableCell {
    func configure(withAny input: Any) {
        if let contentType = input as? ContentType {
            configure(withContentType: contentType)
        }
    }
}
