//
//  UISearchBar+ColorChanging.swift
//
//
//  Created by vladimir.kuzomenskyi on 3/17/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

extension UISearchBar {
    // MARK: - Function
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    
    func set(textColor: UIColor) { if let textField = getTextField() { textField.textColor = textColor } }
    
    func setTextField(font: UIFont? = nil, backgroundColor: UIColor? = nil, textColor: UIColor? = nil) {
        guard let textField = getTextField() else { return }
        textField.font = font
        textField.backgroundColor = backgroundColor
        textField.textColor = textColor
    }

    func setSearchImage(color: UIColor) {
        guard let imageView = getTextField()?.leftView as? UIImageView else { return }
        imageView.tintColor = color
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
    }
}
