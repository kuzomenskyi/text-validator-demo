//
//  Animation.swift
//  drop-down-menu
//
//  Created by vladimir.kuzomenskyi on 5/23/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

struct Animation {
    var duration: TimeInterval? = nil
    var delay: TimeInterval? = nil
    var springWithDamping: CGFloat? = nil
    var initialSpringVelocity: CGFloat? = nil
    var options: UIView.AnimationOptions? = nil
    var block: Completion
    var completion: BoolCompletion? = nil
}
