//
//  Application.swift
//  UpcomingMovies
//
//  Created by Tatiane Souza on 17/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform

final class Application {
    
    static let shared = Application()
    
    let imageUrl = "https://image.tmdb.org/t/p/w138_and_h175_face"
    
    private let useCaseProvider: Domain.UseCaseProvider
    
    // MARK: - Init
    private init() {
        useCaseProvider = NetworkPlatform.UseCaseProvider()
    }
    
    func configureMainInterface(in window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = UINavigationController()
        
        window.rootViewController = navigationController
        
        let moviesNavigator = DefaultMoviesNavigator(services: useCaseProvider,
                                                     navigationController: navigationController,
                                                     storyBoard: storyboard)
        moviesNavigator.toMovies()
    }
}
