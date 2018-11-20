//
//  DetailViewModel.swift
//  UpcomingMovies
//
//  Created by Tatiane Souza on 20/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation
import Domain

final class DetailViewModel: ViewModelType {
    
    let movie: Movie
    let genre: String
    let poster: String
    let backdrop: String
    
    private let navigator: DetailNavigator
    
    init(navigator: DetailNavigator, movie: Movie, genre: String) {
        self.navigator = navigator
        self.movie = movie
        self.genre = genre
        
        poster = "\(Application.shared.imageUrl)\(movie.posterPath ?? "")"
        backdrop = "\(Application.shared.imageUrl)\(movie.backdropPath ?? "")"
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}

extension DetailViewModel {
    
    struct Input {
    }
    
    struct Output {
    }
}

