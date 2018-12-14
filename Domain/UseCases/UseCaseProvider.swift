//
//  UseCaseProvider.swift
//  Domain
//
//  Created by Tatiane Souza on 16/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation

public protocol UseCaseProvider {
    func makeMoviesUseCase() -> MoviesUseCase
}
