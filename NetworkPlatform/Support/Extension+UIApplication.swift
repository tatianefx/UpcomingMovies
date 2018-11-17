//
//  Extension+UIApplication.swift
//  NetworkPlatform
//
//  Created by Tatiane Souza on 17/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation

extension UIApplication {
    
    static var apiKey: String? {
        return Bundle.main.path(forResource: "Urls", ofType: "plist")
    }
}
