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
    let movie: Movie

    init (with movie: Movie) {
        self.title = movie.title
        self.movie = movie
    }
}
