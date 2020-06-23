//
//  TextValidator.swift
//  text-validator-demo
//
//  Created by Vladimir Kuzomenskyi on 25.02.2020.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import Foundation

protocol TextValidator: class {
    func validate(_ text: String?, textFieldName: String?, withRules rules: ValidationRules, completion: @escaping (Error?) -> Void)
}

extension TextValidator {
    var defaultErrorName: String { return "Error" }
    var defaultMaxTextLength: Int { return 100 }
    
    // MARK: - Function
    func validate(_ text: String?, textFieldName: String?, withRules rules: ValidationRules, completion: @escaping (Error?) -> Void) {
        let isThereNoRulesContradiction = !(rules.mustContainOnlyLetters ?? false && rules.mustContainOnlyNumbers ?? false)
        assert(isThereNoRulesContradiction, "@@@@@ TextValidator's mustContainOnlyLetters and mustContainOnlyNumbers validation rules cannot be satisfied simultaneously")
        var error: Error? = nil {
            didSet {
                completion(error)
            }
        }
        
        let textFieldName = textFieldName ?? "Text"
        
        if !isLengthValid(text, withRules: rules) {
            let description = "\(textFieldName) length should be between \(rules.minLength ?? 0)-\(rules.maxLength ?? defaultMaxTextLength) symbols."
            let invalidLength = CustomError(title: defaultErrorName, description: description, code: 1)
            error = invalidLength
        }
        
        if areBannedSymbolsIncluded(text, withRules: rules), let bannedSymbols = rules.bannedSymbols {
            let bannedSymbolsList = getBannedSymbolsPrintingString(bannedSymbols)
            let description = "Usage of \(bannedSymbolsList) symbols is not allowed"
            let usageOfBannedSymbols = CustomError(title: defaultErrorName, description: description, code: 2)
            error = usageOfBannedSymbols
        }
        
        if !areUppercaseAndLowercaseSymbolsIncluded(text, withRules: rules), rules.requiresBothUppercaseAndLowercase ?? false {
            let description = "Usage of at least one lowercase and at least one uppercase letters required"
            let absentOfUppercaseOrLowercaseSymbol = CustomError(title: defaultErrorName, description: description, code: 3)
            error = absentOfUppercaseOrLowercaseSymbol
        }
        
        if !isAtLeastOneNumberAndCharacterIncluded(text, withRules: rules) && rules.requiresAtLeastOneNumberAndCharacter ?? false {
            let description = "Usage of at least one number and at least one character is required"
            let usageOfBannedSymbols = CustomError(title: defaultErrorName, description: description, code: 2)
            error = usageOfBannedSymbols
        }
        
        if !isContainsOnlyWhiteListSymbols(text, withRules: rules), let whiteListSymbols = rules.whiteListSymbols {
            var symbolsToPrint = ""
            for symbol in whiteListSymbols.enumerated() {
                let separator = ", "
                if symbol.offset != (whiteListSymbols.count - 1) {
                    symbolsToPrint.append(String(symbol.element) + separator)
                } else {
                    symbolsToPrint.append(symbol.element)
                }
            }
            
            let description = "Usage of all symbols except \(symbolsToPrint) is not allowed for \(textFieldName) field"
            let usageOfBannedSymbols = CustomError(title: defaultErrorName, description: description, code: 2)
            error = usageOfBannedSymbols
        }
        
        if !isContainsOnlyLetters(text, withRules: rules), rules.mustContainOnlyLetters ?? false {
            let description = "Usage of numbers is not allowed for \(textFieldName) field"
            let usageOfBannedSymbols = CustomError(title: defaultErrorName, description: description, code: 2)
            error = usageOfBannedSymbols
        }
        
        if !isContainsOnlyNumbers(text, withRules: rules), rules.mustContainOnlyNumbers ?? false {
            let description = "Usage of letters is not allowed for \(textFieldName) field"
            let usageOfBannedSymbols = CustomError(title: defaultErrorName, description: description, code: 2)
            error = usageOfBannedSymbols
        }
    }
    
    // MARK: - Private Function
    private func isLengthValid(_ text: String?, withRules rules: ValidationRules) -> Bool {
        guard let text = text else { return false }
        
        let spaceSymbol: Character = " "
        let textWithoutSpaces = text.filter { $0 != spaceSymbol }
        let numberOfSymbolsExceptSpaces = textWithoutSpaces.count
        var output = true
        
        var isMinLengthValid: Bool {
            if let minLength = rules.minLength {
                var numberOfSymbols = 0
                
                if let areSpaceSymbolsConsidered = rules.areSpaceSymbolsConsidered, areSpaceSymbolsConsidered {
                    numberOfSymbols = numberOfSymbolsExceptSpaces
                } else {
                    numberOfSymbols = text.count
                }
                return numberOfSymbols >= Int(minLength)
            } else {
                return false
            }
        }
        
        var isMaxLengthValid: Bool {
            let maxLength = rules.maxLength ?? defaultMaxTextLength
            var numberOfSymbols = 0
            
            if let areSpaceSymbolsConsidered = rules.areSpaceSymbolsConsidered, areSpaceSymbolsConsidered {
                numberOfSymbols = numberOfSymbolsExceptSpaces
            } else {
                numberOfSymbols = text.count
            }
            return numberOfSymbols <= Int(maxLength)
        }
        
        return isMinLengthValid && isMaxLengthValid
    }
    
    private func areBannedSymbolsIncluded(_ text: String?, withRules rules: ValidationRules) -> Bool {
        guard let text = text, let bannedSymbolsString = rules.bannedSymbols else { return false }
        let bannedSymbols = Array(bannedSymbolsString).compactMap { $0 as Character }
        var output = false
        
        bannedSymbols.forEach { (bannedSymbol) in
            text.forEach { (symbol) in
                if String(symbol.lowercased()) == bannedSymbol.lowercased() {
                    output = true
                }
            }
        }
        return output
    }
    
    private func getBannedSymbolsPrintingString(_ bannedSymbols: String) -> String {
        var output = ""
        for symbol in bannedSymbols.enumerated() {
            let isNotLastSymbol = symbol.offset != (bannedSymbols.count - 1)
            output.append("\"\(symbol.element.lowercased())\"")
            if isNotLastSymbol {
                output.append(", ")
            }
        }
        return output
    }
    
    private func areUppercaseAndLowercaseSymbolsIncluded(_ text: String?, withRules rules: ValidationRules) -> Bool {
        let lowercaseLetterRegEx = ".*[a-z]+.*"
        let lowercasePredicate = NSPredicate(format:"SELF MATCHES %@", lowercaseLetterRegEx)
        let areLowercaseSymbolsIncluded = lowercasePredicate.evaluate(with: text)
        
        let uppercaseLetterRegEx = ".*[A-Z]+.*"
        let uppercasePredicate = NSPredicate(format:"SELF MATCHES %@", uppercaseLetterRegEx)
        let areUppecaseSymbolsIncluded = uppercasePredicate.evaluate(with: text)
        
        return areLowercaseSymbolsIncluded && areUppecaseSymbolsIncluded
    }
    
    private func isAtLeastOneNumberAndCharacterIncluded(_ text: String?, withRules rules: ValidationRules) -> Bool {
        let lettersRegEx = ".*[a-zA-Z]+.*"
        let letterPredicate = NSPredicate(format: "SELF MATCHES %@", lettersRegEx)
        let isLetterIncluded = letterPredicate.evaluate(with: text)
        
        let numberRegEx = ".*[0-9]+.*"
        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        let isNumberIncluded = numberPredicate.evaluate(with: text)
        
        return isLetterIncluded && isNumberIncluded
    }
    
    private func isContainsOnlyWhiteListSymbols(_ text: String?, withRules rules: ValidationRules) -> Bool {
        guard let text = text, let whiteListSymbols = rules.whiteListSymbols else { return false }
        var textToExamine = text
        
        whiteListSymbols.forEach { (whiteListSymbol) in
            textToExamine.forEach { (symbol) in
                if String(symbol.lowercased()) == whiteListSymbol.lowercased() {
                    textToExamine.removeAll { $0.lowercased() == whiteListSymbol.lowercased() }
                }
            }
        }
        return textToExamine.isEmpty
    }
    
    private func isContainsOnlyNumbers(_ text: String?, withRules rules: ValidationRules) -> Bool {
        let numbers = Array(0...9).map { "\($0)" }.joined(separator: "")
        var newRules = rules
        newRules.whiteListSymbols = numbers
        
        return isContainsOnlyWhiteListSymbols(text, withRules: newRules)
    }
    
    private func isContainsOnlyLetters(_ text: String?, withRules rules: ValidationRules) -> Bool {
        let letters = (65..<(65+26))
        .map(UnicodeScalar.init)
            .map({ String($0) }).joined(separator: "")
        var newRules = rules
        newRules.whiteListSymbols = letters
        
        return isContainsOnlyWhiteListSymbols(text, withRules: newRules)
    }
}
