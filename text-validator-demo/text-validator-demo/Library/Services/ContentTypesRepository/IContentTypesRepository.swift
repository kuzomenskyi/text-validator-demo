//
//  IContentTypesRepository.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/25/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import Foundation

protocol IContentTypesRepository: class {
    var storage: [ContentType] { get set }
}
