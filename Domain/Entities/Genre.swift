//
//  Genre.swift
//  Domain
//
//  Created by Tatiane Souza on 16/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation

public struct Genre: Decodable {
    
    let id: Int
    let name: String
    
    enum GenreCodingKeys: String, CodingKey {
        case id
        case name
    }
}
