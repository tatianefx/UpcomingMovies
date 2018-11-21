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
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let disposeBag = DisposeBag()
    var viewModel: MoviesViewModel!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupTableViewBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        /// Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        /// Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
            .take(1)
            .asDriverOnErrorJustComplete()
        
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let cancelSearch = searchBar.rx.cancelButtonClicked
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = MoviesViewModel.Input(searchTrigger: searchBar.rx.text.orEmpty.changed.asDriver().throttle(0.5),
                                          selection: tableView.rx.itemSelected.asDriver(),
                                          refreshTrigger: Driver.merge(viewWillAppear, pull, cancelSearch),
                                          loadNextPageTrigger: tableView.rx_reachedBottom)
        
        let output = viewModel.transform(input: input)
        
        setupSearchBar()
        bindingMovies(output)
        refreshControl(output)
        selectedItem(output)
        showErros(output)
        showEmptyView(output)
    }
    
    // MARK: - Private methods
    private func bindingMovies(_ output: MoviesViewModel.Output) {
        output.movies
            .drive(tableView.rx.items(cellIdentifier: MovieTableViewCell.reuseId,
                                        cellType: MovieTableViewCell.self)) { row, viewModel, cell in
                                            cell.bind(viewModel)
            }.disposed(by: disposeBag)
    }
    
    private func setupSearchBar() {
        tableView.rx.contentOffset
            .subscribe { [unowned self] _ in
                if self.searchBar.isFirstResponder {
                    _ = self.searchBar.resignFirstResponder()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func refreshControl(_ output: MoviesViewModel.Output) {
        output.fetching
            .do(onNext: { [unowned self] isRefreshing in
                self.viewModel.loading.accept(isRefreshing)
                self.tableView.reloadData()
            })
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func selectedItem(_ output: MoviesViewModel.Output) {
        output.selectedMovie
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func showErros(_ output: MoviesViewModel.Output) {
        output.error
            .drive(onNext: { [weak self] error in
                self?.showAlert("Alert", message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func showEmptyView(_ output: MoviesViewModel.Output) {
        output.empty
            .drive(onNext: { [weak self] isEmpty in
                self?.emptyView.isHidden = !isEmpty
            })
            .disposed(by: disposeBag)
    }

}

// MARK: - Alert
extension MoviesViewController {
    
    fileprivate func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
