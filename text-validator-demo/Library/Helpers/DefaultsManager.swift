//
//  DefaultsManager.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/26/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import Foundation

protocol DefaultsManager: AnyObject {
    
}

extension DefaultsManager {
    // MARK: Variable
    
    // MARK: Function
    func setDefaultsValue<T: Any>(_ value: T, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func getDefaultsValue(forKey key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }

    func eraseDefaultsValue(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
