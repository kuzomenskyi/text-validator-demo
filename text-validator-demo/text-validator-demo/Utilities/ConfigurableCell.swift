//
//  ConfigurableCell.swift
//
//
//  Created by vladimir.kuzomenskyi on 5/22/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

protocol ConfigurableCell: UITableViewCell {
    func configure(withAny input: Any)
}
