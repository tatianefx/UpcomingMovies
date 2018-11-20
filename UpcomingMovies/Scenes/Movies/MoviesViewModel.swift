//
//  MoviesViewModel.swift
//  UpcomingMovies
//
//  Created by Tatiane Souza on 16/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Domain

class MoviesViewModel: ViewModelType {
    
    private let useCase: MoviesUseCase
    private let navigator: MoviesNavigator
    
    init(useCase: MoviesUseCase,
         navigator: MoviesNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: MoviesViewModel.Input) -> MoviesViewModel.Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let movies = fetchMovies(input, activityIndicator, errorTracker)
        let selectedMovie = hasMovieSelected(input, movies)
        
        let empty = movies.asDriver().map { list -> Bool in
            return list.isEmpty
        }
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        
        return Output(fetching: fetching, movies: movies, selectedMovie: selectedMovie, error: errors, empty: empty)
    }
    
    private func fetchMovies(_ input: MoviesViewModel.Input,_ activityIndicator: ActivityIndicator,_ errorTracker: ErrorTracker) -> Driver<[MovieItemViewModel]> {
        return input.trigger.flatMapLatest { [unowned self] _ in
            self.useCase.movies(page: 1) //TODO pagination
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
            }.flatMapLatest{ [unowned self] movies in
                return self.useCase.genres()
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .map { genres  in
                        movies.results.map { movie in
                            self.createMovieItemViewModel(movie, genres.genres)
                        }
                    }
            }
    }
    
    private func createMovieItemViewModel(_ movie: Movie,_ genres: [Genre]) -> MovieItemViewModel {
        let movieGenre = genres
            .filter({ movie.genreIds.contains($0.id) })
            .map({ $0.name })
        return MovieItemViewModel(with: movie, genres: movieGenre)
    }
    
    private func hasMovieSelected(_ input: MoviesViewModel.Input,_ movies: Driver<[MovieItemViewModel]>) -> Driver<(Movie, String)> {
        return input.selection.withLatestFrom(movies) { (indexPath, movies) -> (Movie, String) in
            return (movies[indexPath.row].movie, movies[indexPath.row].genres)
            }.do(onNext: navigator.toDetails)
    }
}

extension MoviesViewModel {
    
    struct Input {
        let trigger: Driver<Void>
        let selection: Driver<IndexPath>
    }
    
    struct Output {
        let fetching: Driver<Bool>
        let movies: Driver<[MovieItemViewModel]>
        let selectedMovie: Driver<(Movie, String)>
        let error: Driver<Error>
        let empty: Driver<Bool>
    }
}
