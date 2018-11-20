//
//  DetailNavigator.swift
//  UpcomingMovies
//
//  Created by Tatiane Souza on 20/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import UIKit

protocol DetailNavigator {
    
    func toMovies()
}

final class DefaultDetailNavigator: DetailNavigator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toMovies() {
        navigationController.dismiss(animated: true)
    }
}
