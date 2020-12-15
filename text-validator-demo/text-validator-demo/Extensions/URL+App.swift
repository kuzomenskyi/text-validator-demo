//
//  URL+App.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/24/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

extension URL {
    struct App {
        static let placeholderImageURL = URL(string: "https://www.argola.com/wp-content/uploads/placeholder-blue-800x600px.png")
        static let passwordImageURL = URL(string: "https://ip-calculator.ru/blog/wp-content/uploads/2019/09/newsroom-hero-image-password-security-1.png")
        static let userProfileImageURL = URL(string: "https://www.nebeep.com/wp-content/uploads/2020/02/d24adbfca8749fed45b893ab6556fa36.jpg")
        static let ageImageURL = URL(string: "https://thefastingmethod.com/wp-content/uploads/Aging1.jpg")
    }
    
    func getBase64DecodedData() -> String? {
        var imageFile: String?
        
        if let data = try? Data(contentsOf: self), let image = UIImage(data: data) {
            let imageData = image.pngData()
            let strBase64 = imageData?.base64EncodedString(options: .lineLength64Characters)
            
            imageFile = strBase64 ?? nil
        }
        return imageFile
    }
}
