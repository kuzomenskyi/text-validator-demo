//
//  CustomFont.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 3/13/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

extension UIFont {
    enum Style: String {
        case bold = "-Bold"
        case demiBold = "-Demibold"
        case demiBoldItalic = "-DemiboldItalic"
        case heavy = "-Heavy"
        case heavyItalic = "-HeavyItalic"
        case medium = "-Medium"
        case mediumItalic = "-MediumItalic"
        case ultraLight = "-Ultralight"
        case ultraLightItalic = "-UltralightItalic"
        case extraboldItalic = "-ExtraboldItalic"
        case semiboldItalic = "-SemiboldItalic"
        case semibold = "-Semibold"
        case regular = ""
        case lightItalic = "Light-Italic"
        case light = "-Light"
        case roman = "-Roman"
        case italic = "-Italic"
        case extraBold = "-Extrabold"
        case boldItalic = "-BoldItalic"
        case normal = "-Normal"
    }

    enum Name: String {
        case avenirNext = "AvenirNext"
        case avenir = "Avenir"
    }

    static func fontWithProperties(name: Name, style: Style, size: CGFloat) -> UIFont? {
        return UIFont(name: "\(name)\(style.rawValue)", size: size)
    }

    static func fontWithProperties(name: String, style: Style, size: CGFloat) -> UIFont? {
        return UIFont(name: "\(name)\(style.rawValue)", size: size)
    }
}
