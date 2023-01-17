//
//  CustomError.swift
//  text-validator-demo
//
//  Created by Vladimir Kuzomenskyi on 25.02.2020.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import Foundation

class CustomError: NSError {
    var title: String?
    var errorDescription: String
    var errorCode: Int
    
    override var code: Int {
        return errorCode
    }

    override var localizedDescription: String {
        return errorDescription
    }
    
    init(title: String?, description: String, code: Int) {
        self.title = title ?? "Error"
        self.errorDescription = description
        self.errorCode = code
        super.init(domain: "", code: code, userInfo: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
