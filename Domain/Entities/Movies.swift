//
//  Movies.swift
//  Domain
//
//  Created by Tatiane Souza on 16/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation

public struct Movies: Decodable {
    
    let page: Int
    let totalResults: Int
    let total_pages: Int
    let results: [Movie]
    
    enum MoviesCodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
