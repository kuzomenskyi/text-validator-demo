//
//  ContentType.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/23/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import Foundation

struct ContentType {
    var name: String
    var rules: ValidationRules?
    
    enum Name: String {
        case none, username, age, password
    }
}
