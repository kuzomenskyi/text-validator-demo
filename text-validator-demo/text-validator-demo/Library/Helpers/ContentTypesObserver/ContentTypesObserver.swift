//
//  ContentTypesObserver.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/25/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import Foundation

class ContentTypesObserver: IContentTypesObserver {
    // MARK: Constant
    
    // MARK: Variable
    private var notificationCenter = NotificationCenter.default
    
    // MARK: Init
    
    // MARK: Function
    func observeForDatabaseContentUpdate(handler: @escaping NotificationCompletion) {
        // swiftlint:disable:next discarded_notification_center_observer
        notificationCenter.addObserver(forName: Notification.Name.App.databaseContentUpdateNotification, object: nil, queue: .main, using: handler)
    }
    
    // MARK: - Deinit
    deinit {
        notificationCenter.removeObserver(self)
    }
}
