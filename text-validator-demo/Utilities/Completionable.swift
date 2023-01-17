//
//  Completionable.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/26/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import Foundation

@objc protocol Completionable {
    @objc optional var cellCompletion: CellCompletion? { get set }
    
    func setCellCompletion(completion: CellCompletion?)
}
