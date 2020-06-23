//
//  Action.swift
//
//
//  Created by vladimir.kuzomenskyi on 5/22/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

struct Action {
    var target: Any?
    var selector: Selector?
    var title: String?
    var style: UIAlertAction.Style?
    var handler: Completion?
}
