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
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        
        return Output(fetching: fetching, movies: movies, selectedMovie: selectedMovie, error: errors)
    }
    
    private func fetchMovies(_ input: MoviesViewModel.Input,_ activityIndicator: ActivityIndicator,_ errorTracker: ErrorTracker) -> Driver<[MovieItemViewModel]> {
        return input.trigger.flatMapLatest { [unowned self] _ in
            return self.useCase.movies(page: 1, title: "", todayDate: Date().transformToJsonString())
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map { $0.results.map { MovieItemViewModel(with: $0) } }
        }
    }
    
    private func hasMovieSelected(_ input: MoviesViewModel.Input,_ movies: Driver<[MovieItemViewModel]>) -> Driver<Movie> {
        return input.selection.withLatestFrom(movies) { (indexPath, movies) -> Movie in
            return movies[indexPath.row].movie
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
        let selectedMovie: Driver<Movie>
        let error: Driver<Error>
    }
}
