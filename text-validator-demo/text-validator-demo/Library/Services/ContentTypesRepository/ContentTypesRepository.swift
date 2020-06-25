//
//  ContentTypesRepository.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/25/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import Foundation
import SQLite

class ContentTypesRepository: IContentTypesRepository {
    // MARK: Constant
    
    // MARK: Private Constant
    private let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true ).first!
    private let contentTypes = Table("ContentTypes")
    
    private let name = Expression<String>("name")
//    private let rules = Expression<ValidationRules?>("rules")
    private let imageURL = Expression<String?>("imageURL")
    private let minLength = Expression<Int?>("minLength")
    private let maxLength = Expression<Int?>("maxLength")
    private let areSpaceSymbolsConsidered = Expression<Bool?>("areSpaceSymbolsConsidered")
    private let bannedSymbols = Expression<String?>("bannedSymbols")
    private let whiteListSymbols = Expression<String?>("whiteListSymbols")
    private let requiresBothUppercaseAndLowercase = Expression<Bool?>("requiresBothUppercaseAndLowercase")
    private let requiresAtLeastOneNumberAndCharacter = Expression<Bool?>("requiresAtLeastOneNumberAndCharacter")
    private let mustContainOnlyNumbers = Expression<Bool?>("mustContainOnlyNumbers")
    private let mustContainOnlyLetters = Expression<Bool?>("mustContainOnlyLetters")

    // MARK: Variable
    
    // MARK: Private Variable
    lazy var db = try? Connection("\(path)/db.sqlite3")
    
    // MARK: Init
    init() {
        do {
            try db?.run(contentTypes.create { t in
                t.column(name, unique: true)
                t.column(imageURL)
                t.column(minLength)
                t.column(maxLength)
                t.column(areSpaceSymbolsConsidered)
                t.column(bannedSymbols)
                t.column(whiteListSymbols)
                t.column(requiresBothUppercaseAndLowercase)
                t.column(requiresAtLeastOneNumberAndCharacter)
                t.column(mustContainOnlyNumbers)
                t.column(mustContainOnlyLetters)
            })
        } catch(let error) {
            print("@@@@@ An error occured while creating database:", error)
        }
    }
    
    // MARK: Action
    
    // MARK: Function
    func getContentTypes() -> [ContentType] {
        var output = [ContentType]()
        
        do {
            if let contentTypes = try db?.prepare(self.contentTypes) {
                output = contentTypes.map {
                    let rules = ValidationRules(minLength: UInt($0[minLength] ?? 0), maxLength: $0[maxLength], areSpaceSymbolsConsidered: $0[areSpaceSymbolsConsidered], bannedSymbols: $0[bannedSymbols], whiteListSymbols: $0[whiteListSymbols], requiresBothUppercaseAndLowercase: $0[requiresBothUppercaseAndLowercase], requiresAtLeastOneNumberAndCharacter: $0[requiresAtLeastOneNumberAndCharacter], mustContainOnlyNumbers: $0[mustContainOnlyNumbers], mustContainOnlyLetters: $0[mustContainOnlyLetters])
                    
                    var type = ContentType(name: $0[name], rules: rules)
                    if let imageURL = $0[imageURL] {
                        type.imageURL = URL(string: imageURL)
                    }
                    return type
                }
            }
        } catch {
            print("@@@@@ An error occured while getting content types")
        }
        
        return output
    }

    func insert(contentType: ContentType) {
        let type = contentType
        let rules = type.rules
        let insertContentType = contentTypes.insert(
            name <- type.name,
            imageURL <- type.imageURL?.absoluteString ?? nil,
            minLength <- Int(rules?.minLength ?? 0),
            maxLength <- rules?.maxLength,
            areSpaceSymbolsConsidered <- rules?.areSpaceSymbolsConsidered,
            bannedSymbols <- rules?.bannedSymbols,
            whiteListSymbols <- rules?.whiteListSymbols,
            requiresBothUppercaseAndLowercase <- rules?.requiresBothUppercaseAndLowercase,
            requiresAtLeastOneNumberAndCharacter <- rules?.requiresAtLeastOneNumberAndCharacter,
            mustContainOnlyNumbers <- rules?.mustContainOnlyNumbers,
            mustContainOnlyLetters <- rules?.mustContainOnlyLetters
        )
        
        do {
            try db?.run(insertContentType)
            print("successfully inserted content type")
        } catch(let error) {
            print("@@@@@ An error occured while insering contentType:", error)
        }
    }
    
    func update(contentTypeWithName name: String, newType: ContentType) {
        let type = contentTypes.filter(self.name == name)
        let newRules = newType.rules
        
        let updateContentType = type.update(
            self.name <- newType.name,
            imageURL <- newType.imageURL?.absoluteString,
            minLength <- Int(newRules?.minLength ?? 0),
            maxLength <- newRules?.maxLength,
            areSpaceSymbolsConsidered <- newRules?.areSpaceSymbolsConsidered,
            bannedSymbols <- newRules?.bannedSymbols,
            whiteListSymbols <- newRules?.whiteListSymbols,
            requiresBothUppercaseAndLowercase <- newRules?.requiresBothUppercaseAndLowercase,
            requiresAtLeastOneNumberAndCharacter <- newRules?.requiresAtLeastOneNumberAndCharacter,
            mustContainOnlyNumbers <- newRules?.mustContainOnlyNumbers,
            mustContainOnlyLetters <- newRules?.mustContainOnlyLetters
        )
        
        do {
            try db?.run(updateContentType)
            print("successfully updated content type")
        } catch {
            print("@@@@@ An error occured while updating content types")
        }
    }
    
    func delete(contentTypeWithName name: String) {
        let type = contentTypes.filter(self.name == name)
        let deleteType = type.delete()
        
        do {
            try db?.run(deleteType)
            print("successfully deleted content type")
        } catch {
            print("@@@@@ An error occured while deleting contentType")
        }
    }
}
