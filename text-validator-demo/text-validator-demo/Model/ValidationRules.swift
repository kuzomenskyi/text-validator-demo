//
//  ValidationRules.swift
//  text-validator-demo
//
//  Created by Vladimir Kuzomenskyi on 25.02.2020.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import Foundation

struct ValidationRules {
    var minLength: UInt? = nil, maxLength: Int? = nil
    var areSpaceSymbolsConsidered: Bool? = false
    var bannedSymbols: String? = nil
    var whiteListSymbols: String? = nil
    var requiresBothUppercaseAndLowercase: Bool? = nil
    var requiresAtLeastOneNumberAndCharacter: Bool? = nil
    var mustContainOnlyNumbers: Bool? = nil
    var mustContainOnlyLetters: Bool? = nil
}
