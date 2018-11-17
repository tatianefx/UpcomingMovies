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
        //TODO
        return Output()
    }
}

extension MoviesViewModel {
    
    struct Input {
    }
    
    struct Output {
    }
}
