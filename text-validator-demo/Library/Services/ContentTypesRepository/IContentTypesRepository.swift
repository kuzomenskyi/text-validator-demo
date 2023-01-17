//
//  IContentTypesRepository.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/25/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import Foundation

protocol IContentTypesRepository: AnyObject {
    func getContentTypes() -> [ContentType]
    func insert(contentType: ContentType)
    func update(contentTypeWithName name: String, newType: ContentType)
    func delete(contentTypeWithName name: String)
}
