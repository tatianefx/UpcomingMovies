//
//  MovieTableViewCell.swift
//  UpcomingMovies
//
//  Created by Tatiane Souza on 17/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    func bind(_ viewModel: MovieItemViewModel) {
        self.titleLabel.text = viewModel.title
    }

}
