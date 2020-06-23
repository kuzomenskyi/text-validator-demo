//
//  DropDownMenuCell.swift
//  Liquor Sales
//
//  Created by vladimir.kuzomenskyi on 5/29/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

class DropDownMenuCell: UITableViewCell {
    // MARK: Constant
    
    // MARK: Variable
    
    // MARK: Outlet
    @IBOutlet var label: UILabel!
    
    // MARK: Init
    
    // MARK: Action
    
    // MARK: Private Function
    private func configure(withString string: String) {
        label.text = string
    }
}

extension DropDownMenuCell: ConfigurableCell {
    func configure(withAny input: Any) {
        if let string = input as? String {
            configure(withString: string)
        }
    }
}
