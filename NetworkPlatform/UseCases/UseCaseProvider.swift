//
//  UseCaseProvider.swift
//  NetworkPlatform
//
//  Created by Tatiane Souza on 16/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation
import RxSwift
import Domain
import Moya

public final class UseCaseProvider: Domain.UseCaseProvider {

    private let networkProvider: MoyaProvider<TheMovieDatabase>
    
    // MARK: - Init
    public init() {
        networkProvider = MoyaProvider<TheMovieDatabase>()
    }
    
    public func makeMoviesUseCase() -> Domain.MoviesUseCase {
        return MoviesUseCase(provider: networkProvider)
    }
    
}

