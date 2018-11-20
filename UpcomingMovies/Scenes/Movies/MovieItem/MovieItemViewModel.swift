//
//  MovieItemViewModel.swift
//  UpcomingMovies
//
//  Created by Tatiane Souza on 17/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Domain

final class MovieItemViewModel   {

    let title: String
    let genres: String
    let releaseDateLabel: String
    let poster: Observable<UIImage>
    let movie: Movie
    
    private let posterUrl: BehaviorRelay<String>

    init (with movie: Movie, genres: [String]) {
        self.movie = movie
        self.genres = genres.joined(separator: " | ")
        title = movie.title
        releaseDateLabel = movie.releaseDate
        
        let path = movie.posterPath ?? movie.backdropPath ?? ""
        posterUrl = BehaviorRelay(value: "\(Application.shared.imageUrl)\(path)")
        
        poster = posterUrl.asObservable()
            .subscribeOn(CurrentThreadScheduler.instance) // `subscribeOn(CurrentThreadScheduler.instance)` is here so you can cancel scheduling of network operation in case something is returned from memory
            .observeOn(MainScheduler.instance)
            .map { (url) -> UIImage in
            guard let url = URL(string: url),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else { return UIImage() }
            return image
        }
            .take(1)
    }
    
}
