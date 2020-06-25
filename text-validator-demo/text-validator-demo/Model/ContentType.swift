//
//  ContentType.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/23/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

struct ContentType {
    var name: String
    var rules: ValidationRules?
    var imageURL: URL?
    var image: UIImage?
    
    enum Name: String {
        case none, username, age, password
    }
}
