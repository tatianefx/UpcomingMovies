//
//  MoviesUseCase.swift
//  NetworkPlatform
//
//  Created by Tatiane Souza on 17/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation
import RxSwift
import Domain
import Moya

final class MoviesUseCase: Domain.MoviesUseCase {
    
    private let disposeBag = DisposeBag()
    private let provider: MoyaProvider<TheMovieDatabase>
    
    // MARK: - Init
    init(provider: MoyaProvider<TheMovieDatabase>) {
        self.provider = provider
    }
    
    func movies(page: Int?) -> Observable<Movies> {
        return provider.rx.request(TheMovieDatabase.movies(page: page))
            .map(Movies.self)
            .debug()
            .asObservable()
    }
    
    func search(page: Int?, title: String?) -> Observable<Movies> {
        return provider.rx.request(TheMovieDatabase.search(page: page, title: title))
            .map(Movies.self)
            .debug()
            .asObservable()
    }
    
    func genres() -> Observable<Genres> {
        return provider.rx.request(TheMovieDatabase.genres())
            .filterSuccessfulStatusCodes()
            .map(Genres.self)
            .debug()
            .asObservable()
    }
}
