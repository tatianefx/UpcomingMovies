//
//  Movies.swift
//  Domain
//
//  Created by Tatiane Souza on 16/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation

public struct Movies: Decodable {
    
    public let page: Int
    public let totalResults: Int
    public let totalPages: Int
    public let results: [Movie]
    
    // MARK: - Init
    public init(page: Int,
                totalResults: Int,
                totalPages: Int,
                results: [Movie]) {
        self.page = page
        self.totalResults = totalResults
        self.totalPages = totalPages
        self.results = results
    }
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
    
    public init(from decoder: Decoder) throws {
        let values   = try decoder.container(keyedBy: CodingKeys.self)
        page         = try values.decode(Int.self, forKey: .page)
        totalResults = try values.decode(Int.self, forKey: .totalResults)
        totalPages   = try values.decode(Int.self, forKey: .totalPages)
        results      = try values.decode([Movie].self, forKey: .results)
    }
}
