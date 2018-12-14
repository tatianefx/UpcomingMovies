//
//  MovieTableViewCell.swift
//  UpcomingMovies
//
//  Created by Tatiane Souza on 17/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import UIKit
import Kingfisher

final class MovieTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    func bind(_ viewModel: MovieItemViewModel) {
        self.titleLabel.text = viewModel.title
        self.genreLabel.text = viewModel.genres
        self.releaseDateLabel.text = viewModel.releaseDateLabel
        posterImageView.kf.setImage(with: URL(string: viewModel.poster))
    }

}
