//
//  UIImage+Ext.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 17.01.2023.
//  Copyright © 2023 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

extension UIImage {
    static let placeholderImage = UIImage(named: "question")!
    static let passwordImage = UIImage(named: "password")!
    static let userProfileImage = UIImage(named: "profile")!
    static let ageImage = UIImage(named: "age")!
    
    func getBase64DecodedData() -> String? {
        var imageFile: String?
        
        let imageData = self.pngData()
        let strBase64 = imageData?.base64EncodedString(options: .lineLength64Characters)
        
        imageFile = strBase64 ?? nil
        return imageFile
    }
}
