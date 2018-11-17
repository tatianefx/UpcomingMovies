//
//  UrlsHelper.swift
//  NetworkPlatform
//
//  Created by Tatiane Souza on 17/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation

final class UrlsHelper {
    
    private init() { }
    
    private var dictionary: [String: String] {
        let path = Bundle.main.path(forResource: "Urls", ofType: "plist")
        return NSDictionary(contentsOfFile: path ?? "") as? [String: String] ?? [:]
    }
    
    static let shared = UrlsHelper()
    
    var apiKey: String {
        return dictionary["apiKey"] ?? ""
    }
    
    var baseUrl: String {
        return dictionary["baseUrl"] ?? ""
    }
    
    var moviesUrl: String {
        return dictionary["moviesUrl"] ?? ""
    }
    
    var genresUrl: String {
        return dictionary["genresUrl"] ?? ""
    }
    
}
