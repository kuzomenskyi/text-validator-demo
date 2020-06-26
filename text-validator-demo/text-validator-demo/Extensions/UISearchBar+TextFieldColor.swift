//
//  UISearchBar+ textFieldColor.swift
//
//
//  Created by anastsia.zhdanova on 8/29/19.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

extension UIView {
    fileprivate func getViewElement<T>(type: T.Type) -> T? {
        for index in 0..<subviews.count {
            if let view = subviews[index] as? T {
                return view
            } else if let view = subviews[index].getViewElement(type: type) {
                return view
            }
        }
        return nil
    }
}

extension UISearchBar {

    func setMagnifyingGlassColor(_ color: UIColor) {
        var magnifier: UIImageView?

        if #available(iOS 13.0, *) {
            magnifier = searchTextField.leftView as? UIImageView
        } else if let textField = getViewElement(type: UITextField.self) {
            magnifier = textField.leftView as? UIImageView
        }

        guard let imageView = magnifier else { return }
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = color
    }

    func setTextFieldColor(color: UIColor) {
        let textField: UITextField?
        if #available(iOS 13, *) {
            textField = searchTextField
        } else {
            textField = getViewElement(type: UITextField.self)
            if searchBarStyle == .minimal, let image = textField?.getViewElement(type: UIImageView.self) {
                image.isHidden = true
            }
        }

        switch searchBarStyle {
        case .minimal:
            textField?.layer.backgroundColor = color.cgColor
            textField?.layer.cornerRadius = 6
        case .prominent, .default:
            textField?.backgroundColor = color
        @unknown default:
            fatalError()
        }
    }

    func setDefaultTextAttributes(_ attributes: [NSAttributedString.Key: Any]) {
        if #available(iOS 13.0, *) {
            searchTextField.defaultTextAttributes = attributes
        } else if let textField = getViewElement(type: UITextField.self) {
            textField.defaultTextAttributes = attributes
        }
    }
}
