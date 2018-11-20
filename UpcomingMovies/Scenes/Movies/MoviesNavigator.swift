//
//  MoviesNavigator.swift
//  UpcomingMovies
//
//  Created by Tatiane Souza on 16/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import UIKit
import Domain

protocol MoviesNavigator {
    func toDetails(_ movie: Movie,_ genre: String)
    func toMovies()
}

class DefaultMoviesNavigator: MoviesNavigator {
    
    private let storyBoard: UIStoryboard
    private let navigationController: UINavigationController
    private let services: UseCaseProvider
    
    init(services: UseCaseProvider,
         navigationController: UINavigationController,
         storyBoard: UIStoryboard) {
        self.services = services
        self.navigationController = navigationController
        self.storyBoard = storyBoard
    }
    
    func toMovies() {
        let vc = storyBoard.instantiateViewController(ofType: MoviesViewController.self)
        vc.viewModel = MoviesViewModel(useCase: services.makeMoviesUseCase(), navigator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toDetails(_ movie: Movie,_ genre: String) {
        let navigator = DefaultDetailNavigator(navigationController: navigationController)
        let vc = storyBoard.instantiateViewController(ofType: DetailViewController.self)
        vc.viewModel = DetailViewModel(navigator: navigator, movie: movie, genre: genre)
        navigationController.pushViewController(vc, animated: true)
    }
}
