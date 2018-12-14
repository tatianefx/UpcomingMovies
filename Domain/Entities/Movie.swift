//
//  Movie.swift
//  Domain
//
//  Created by Tatiane Souza on 16/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation

public struct Movie: Decodable {
    
    public let voteCount: Int
    public let id: Int
    public let video: Bool
    public let voteAverage: Float
    public let title: String
    public let popularity: Float
    public let posterPath: String?
    public let originalLanguage: String
    public let originalTitle: String
    public let genreIds: [Int]
    public let backdropPath: String?
    public let adult: Bool
    public let overview: String
    public let releaseDate: String
    
    // MARK: - Init
    public init(voteCount: Int,
                id: Int,
                video: Bool,
                voteAverage: Float,
                title: String,
                popularity: Float,
                posterPath: String?,
                originalLanguage: String,
                originalTitle: String,
                genreIds: [Int],
                backdropPath: String?,
                adult: Bool,
                overview: String,
                releaseDate: String) {
        self.voteCount = voteCount
        self.id = id
        self.video = video
        self.voteAverage = voteAverage
        self.title = title
        self.popularity = popularity
        self.posterPath = posterPath
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.genreIds = genreIds
        self.backdropPath = backdropPath
        self.adult = adult
        self.overview = overview
        self.releaseDate = releaseDate
    }
    
    private enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case id
        case video
        case voteAverage = "vote_average"
        case title
        case popularity
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIds = "genre_ids"
        case backdropPath = "backdrop_path"
        case adult
        case overview
        case releaseDate = "release_date"
    }
    
    public init(from decoder: Decoder) throws {
        let values       = try decoder.container(keyedBy: CodingKeys.self)
        voteCount        = try values.decode(Int.self, forKey: .voteCount)
        id               = try values.decode(Int.self, forKey: .id)
        video            = try values.decode(Bool.self, forKey: .video)
        voteAverage      = try values.decode(Float.self, forKey: .voteAverage)
        title            = try values.decode(String.self, forKey: .title)
        popularity       = try values.decode(Float .self, forKey: .popularity)
        posterPath       = try values.decode(String?.self, forKey: .posterPath)
        originalLanguage = try values.decode(String.self, forKey: .originalLanguage)
        originalTitle    = try values.decode(String.self, forKey: .originalTitle)
        genreIds         = try values.decode([Int].self, forKey: .genreIds)
        backdropPath     = try values.decode(String?.self, forKey: .backdropPath)
        adult            = try values.decode(Bool.self, forKey: .adult)
        overview         = try values.decode(String.self, forKey: .overview)
        releaseDate      = try values.decode(String.self, forKey: .releaseDate)
    }
}
