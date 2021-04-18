//
//  TextField.swift
//
//
//  Created by vladimir.kuzomenskyi on 6/3/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

#warning("Move that to views")
class TextField: UITextField {
    // MARK: Constant
    
    // MARK: Variable
    var insets: UIEdgeInsets? = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    var title: String?
    var isNumeric: Bool?
    var validationRules: ValidationRules?
    
    // MARK: Init
    convenience init(withInsets insets: UIEdgeInsets) {
        self.init()
        self.insets = insets
    }
    
    // MARK: Action
    
    // MARK: Function
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        var output = bounds
        if let insets = insets {
            output = bounds.inset(by: insets)
        }
        return output
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var output = bounds
        if let insets = insets {
            output = bounds.inset(by: insets)
        }
        return output
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        var output = bounds
        if let insets = insets {
            output = bounds.inset(by: insets)
        }
        return output
    }
}
