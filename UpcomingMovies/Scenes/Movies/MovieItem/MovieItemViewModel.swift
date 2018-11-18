//
//  MovieItemViewModel.swift
//  UpcomingMovies
//
//  Created by Tatiane Souza on 17/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation
import RxSwift
import Domain

final class MovieItemViewModel   {

    let title: String
    let genreLabel: String
    let releaseDateLabel: String
    let poster: Observable<UIImage>
    let posterUrl: Variable<String>
    let movie: Movie

    init (with movie: Movie) {
        self.movie = movie
        self.title = movie.title
        self.genreLabel = "" //TODO
        self.releaseDateLabel = movie.releaseDate
        
        let path = movie.posterPath ?? movie.backdropPath ?? ""
        posterUrl = Variable("\(Application.shared.imageUrl)\(path)")
        
        poster = posterUrl.asObservable().map { (url) -> UIImage in
            guard let url = URL(string: url),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else { return UIImage() }
            return image
        }
    }
    
}
