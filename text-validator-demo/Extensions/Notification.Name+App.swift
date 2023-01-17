//
//  Notification.Name+App.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/25/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import Foundation

extension Notification.Name {
    struct App {
        static let databaseContentUpdateNotification = Notification.Name("DatabaseContentUpdateNotification")
    }
}
