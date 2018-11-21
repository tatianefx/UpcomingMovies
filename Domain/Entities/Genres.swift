//
//  Genres.swift
//  Domain
//
//  Created by Tatiane Souza on 19/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation

public struct Genres: Decodable {
    
    public let genres: [Genre]
    
    // MARK: - Init
    public init(genres: [Genre]) {
        self.genres = genres
    }
    
    private enum CodingKeys: String, CodingKey {
        case genres
    }
    
    public init(from decoder: Decoder) throws {
        let values   = try decoder.container(keyedBy: CodingKeys.self)
        genres       = try values.decode([Genre].self, forKey: .genres)
    }
}
