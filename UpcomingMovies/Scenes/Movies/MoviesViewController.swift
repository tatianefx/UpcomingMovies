//
//  MoviesViewController.swift
//  UpcomingMovies
//
//  Created by Tatiane Souza on 16/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Domain

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    var viewModel: MoviesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupTableViewBinding()
    }
    
    private func configureTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.estimatedRowHeight = 164
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupTableViewBinding() {
        assert(viewModel != nil)
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let input = MoviesViewModel.Input(trigger:  Driver.merge(viewWillAppear, pull),
                                          selection: tableView.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input: input)
        bindingMovies(output)
        refreshControl(output)
        selectedItem(output)
        showErros(output)
    }
    
    private func bindingMovies(_ output: MoviesViewModel.Output) {
        output.movies
            .drive(tableView.rx.items(cellIdentifier: MovieTableViewCell.reuseId,
                                      cellType: MovieTableViewCell.self)) { row, viewModel, cell in
                                        cell.bind(viewModel)
            }.disposed(by: disposeBag)
    }
    
    private func refreshControl(_ output: MoviesViewModel.Output) {
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func selectedItem(_ output: MoviesViewModel.Output) {
        output.selectedMovie
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func showErros(_ output: MoviesViewModel.Output) {
        //TODO show if has error
    }

}
