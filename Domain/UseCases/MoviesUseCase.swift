//
//  MoviesUseCase.swift
//  Domain
//
//  Created by Tatiane Souza on 16/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation
import RxSwift

public protocol MoviesUseCase {
    func movies(page: Int?, title: String?) -> Observable<Movies>
    func genres() -> Observable<[Genre]>
}
