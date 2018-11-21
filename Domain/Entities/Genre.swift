//
//  Genre.swift
//  Domain
//
//  Created by Tatiane Souza on 16/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation

public struct Genre: Decodable {
    
    public let id: Int
    public let name: String
    
    // MARK: - Init
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id         = try values.decode(Int.self, forKey: .id)
        name       = try values.decode(String.self, forKey: .name)
    }
}
