//
//  IScreenEventsObserver.swift
//
//
//  Created by vladimir.kuzomenskyi on 5/23/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import Foundation

protocol IScreenEventsObserver: AnyObject {
    func observeForScreenTransition(handler: @escaping Completion)
}
