//
//  MovieTableViewCell.swift
//  UpcomingMovies
//
//  Created by Tatiane Souza on 17/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    private let disposeBag = DisposeBag()
    
    func bind(_ viewModel: MovieItemViewModel) {
        self.titleLabel.text = viewModel.title
        self.genreLabel.text = viewModel.genres
        self.releaseDateLabel.text = viewModel.releaseDateLabel

        viewModel.poster
            .bind(to: posterImageView.rx.image)
            .disposed(by: disposeBag)
    }

}
