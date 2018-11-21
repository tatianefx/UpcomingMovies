//
//  MovieItemViewModel.swift
//  UpcomingMovies
//
//  Created by Tatiane Souza on 17/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation
import Domain

final class MovieItemViewModel   {

    let title: String
    let genres: String
    let releaseDateLabel: String
    let poster: String
    let movie: Movie

    // MARK: - Init
    init (with movie: Movie, genres: [String]) {
        self.movie = movie
        self.genres = genres.joined(separator: " | ")
        title = movie.title
        releaseDateLabel = movie.releaseDate
        
        let path = movie.posterPath ?? movie.backdropPath ?? ""
        poster = "\(Application.shared.imageUrl)\(path)"
    }
    
}
