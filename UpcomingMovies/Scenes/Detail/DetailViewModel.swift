//
//  DetailViewModel.swift
//  UpcomingMovies
//
//  Created by Tatiane Souza on 20/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Domain

final class DetailViewModel: ViewModelType {
    
    let movie: Movie
    let genre: String
    let poster: Observable<UIImage>
    let backdrop: Observable<UIImage>
    
    private let navigator: DetailNavigator
    private let posterUrl: BehaviorRelay<String>
    private let backdropUrl: BehaviorRelay<String>
    
    init(navigator: DetailNavigator, movie: Movie, genre: String) {
        self.navigator = navigator
        self.movie = movie
        self.genre = genre
        
        posterUrl = BehaviorRelay(value: "\(Application.shared.imageUrl)\(movie.posterPath ?? "")")
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
        
        backdropUrl = BehaviorRelay(value: "\(Application.shared.imageUrl)\(movie.backdropPath ?? "")")
        backdrop = backdropUrl.asObservable()
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

