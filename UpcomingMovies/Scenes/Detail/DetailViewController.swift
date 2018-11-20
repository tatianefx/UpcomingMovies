//
//  DetailViewController.swift
//  UpcomingMovies
//
//  Created by Tatiane Souza on 20/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var viewModel: DetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewBinding()
    }
    
    private func setupViewBinding() {
        assert(viewModel != nil)
        
        titleLabel.text = viewModel.movie.title
        genreLabel.text = viewModel.genre
        releaseDateLabel.text = viewModel.movie.releaseDate
        overviewLabel.text = viewModel.movie.overview
        posterImageView.kf.setImage(with: URL(string: viewModel.poster))
        backdropImageView.kf.setImage(with: URL(string: viewModel.backdrop))
    }

}
