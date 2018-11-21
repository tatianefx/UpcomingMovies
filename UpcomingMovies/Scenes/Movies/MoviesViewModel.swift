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
    
    let loading = BehaviorRelay<Bool>(value: false)
    
    private let hasMorePages = BehaviorRelay<Bool>(value: true)
    private let isSearching = BehaviorRelay<(Bool, String)>(value: (false, ""))
    private let pageNumber = BehaviorRelay<Int>(value: 0)
    
    private let movies = BehaviorRelay<[MovieItemViewModel]>(value:  [])
    private var genres = BehaviorRelay<[Genre]>(value:  [])
    
    private let useCase: MoviesUseCase
    private let navigator: MoviesNavigator
    
    // MARK: - Init
    init(useCase: MoviesUseCase,
         navigator: MoviesNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: MoviesViewModel.Input) -> MoviesViewModel.Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        /// Search trigger
        let search = requestSearch(input, activityIndicator, errorTracker)
        
        /// Refresh trigger
        let refreshRequest = refresh(input, activityIndicator, errorTracker)
        
        /// Load next page trigger
        let nextPageRequest = loadMore(input, activityIndicator, errorTracker)
        
        /// Merge observables
        let request = Observable
            .of(search, refreshRequest, nextPageRequest)
            .merge()
            .asDriverOnErrorJustComplete()
        
        /// Configures MovieItemViewModel for tableview cell
        let movies = request.map { movies -> [MovieItemViewModel] in
                movies.map { [unowned self] movie in
                    self.createMovieItemViewModel(movie, self.genres.value)
                }
            }.do(onNext: { [unowned self] items in
                /// Updates tableview datasource
                self.pageNumber.value <= 1
                    ? self.movies.accept(items)
                    : self.movies.accept(self.movies.value + items)
            })
        
        /// Configures selected movie trigger
        let selectedMovie = hasMovieSelected(input, self.movies.asDriver())
        
        /// Configures empty view
        let empty = movies.asDriver().map { [unowned self] list -> Bool in
            return list.isEmpty && self.pageNumber.value == 1
        }
        
        /// Configures loader
        let fetching = activityIndicator.asDriver().delay(1)
        
        /// Configures errors
        let errors = errorTracker.asDriver()
        
        return Output(fetching: fetching,
                      movies: self.movies.asDriver(),
                      selectedMovie: selectedMovie,
                      error: errors,
                      empty: empty)
    }
    
    /// Search trigger
    private func requestSearch(_ input: MoviesViewModel.Input,_ activityIndicator: ActivityIndicator,_ errorTracker: ErrorTracker) -> Driver<[Movie]> {
        return input.searchTrigger.flatMap { [unowned self] query -> Driver<[Movie]> in
            if self.loading.value || !self.hasMorePages.value {
                return Driver.empty()
            } else {
                self.loading.accept(true)
                if !self.isSearching.value.0 &&
                    self.isSearching.value.1.isEmpty {
                    self.pageNumber.accept(0)
                }
                self.isSearching.accept((true, query))
                return self.fetchSearch(activityIndicator, errorTracker)
            }
        }
    }
    
    /// Fetches movies by search
    private func fetchSearch(_ activityIndicator: ActivityIndicator,_ errorTracker: ErrorTracker) -> Driver<[Movie]> {
            return self.useCase.search(page: self.pageNumber.value + 1, title: self.isSearching.value.1)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .do(onNext: { [unowned self] movies in
                        /// Verifies if has more pages
                        self.hasMorePages.accept(movies.page < movies.totalPages)
                    })
                    .map {  movies -> [Movie] in
                        /// Search result
                        movies.results
                    }
    }
    
    ///  if can request genres and/or movies
    private func refresh(_ input: MoviesViewModel.Input, _ activityIndicator: ActivityIndicator,_ errorTracker: ErrorTracker) -> Driver<[Movie]> {
        return input.refreshTrigger.flatMap { [unowned self] () -> Driver<[Movie]> in
            self.isSearching.accept((false, ""))
            return self.requestMovies(activityIndicator, errorTracker)
        }
    }
    
    ///  if can request genres and/or movies
    private func loadMore(_ input: MoviesViewModel.Input, _ activityIndicator: ActivityIndicator,_ errorTracker: ErrorTracker) -> Driver<[Movie]> {
        return input.loadNextPageTrigger
            .asDriverOnErrorJustComplete()
            .flatMap { [unowned self] () -> Driver<[Movie]> in
                return self.requestMovies(activityIndicator, errorTracker)
        }
    }
    
    ///  if can request genres and/or movies
    private func requestMovies(_ activityIndicator: ActivityIndicator,_ errorTracker: ErrorTracker) -> Driver<[Movie]> {
        if self.loading.value || !self.hasMorePages.value {
            return Driver.empty()
        } else {
            self.loading.accept(true)
            if self.isSearching.value.0 {
                return self.fetchSearch(activityIndicator, errorTracker)
            } else {
                self.isSearching.accept((false, ""))
                if self.genres.value.count > 0 {
                    return self.fetchMovies(activityIndicator, errorTracker)
                } else {
                    return self.fetchGenres(activityIndicator, errorTracker)
                }
            }
        }
    }
    
    /// Fetches movies
    private func fetchMovies(_ activityIndicator: ActivityIndicator,_ errorTracker: ErrorTracker) -> Driver<[Movie]> {
        self.pageNumber.accept(self.pageNumber.value + 1)
        return useCase.movies(page: pageNumber.value)
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .do(onNext: { [unowned self] movies in
                    /// Verifies if has more pages
                    self.hasMorePages.accept(movies.page < movies.totalPages)
                })
                .map{ movies -> [Movie] in
                    /// Result
                    movies.results
                }
    }
    
    /// Fetches genres
    private func fetchGenres(_ activityIndicator: ActivityIndicator,_ errorTracker: ErrorTracker) -> Driver<[Movie]> {
        return useCase.genres()
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .flatMapLatest { [unowned self] genres -> Driver<[Movie]> in
                    /// Stores genres locally
                    self.genres.accept(genres.genres)
                    /// Fetches movies
                    return self.fetchMovies(activityIndicator, errorTracker)
                }
    }

    /// Creates the view model with genres
    private func createMovieItemViewModel(_ movie: Movie,_ genres: [Genre]) -> MovieItemViewModel {
        let movieGenre = genres
            .filter({ movie.genreIds.contains($0.id) })
            .map({ $0.name })
        return MovieItemViewModel(with: movie, genres: movieGenre)
    }
    
    /// Selected movie trigger
    private func hasMovieSelected(_ input: MoviesViewModel.Input,_ movies: Driver<[MovieItemViewModel]>) -> Driver<(Movie, String)> {
        return input.selection.withLatestFrom(movies) { (indexPath, movies) -> (Movie, String) in
            return (movies[indexPath.row].movie, movies[indexPath.row].genres)
            }.do(onNext: navigator.toDetails)
    }
}

extension MoviesViewModel {
    
    // MARK: - Input
    struct Input {
        let searchTrigger: Driver<String>
        let selection: Driver<IndexPath>
        let refreshTrigger: Driver<Void>
        let loadNextPageTrigger: Observable<Void>
    }
    
    // MARK: - Output
    struct Output {
        let fetching: Driver<Bool>
        let movies: Driver<[MovieItemViewModel]>
        let selectedMovie: Driver<(Movie, String)>
        let error: Driver<Error>
        let empty: Driver<Bool>
    }
}
