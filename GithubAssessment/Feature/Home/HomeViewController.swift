//
//  ViewController.swift
//  GithubAssessment
//
//  Created by WanLun on 2024/5/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: String(describing: SearchResultCell.self))
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.searchBarStyle = UISearchBar.Style.default
        search.placeholder = "請輸入關鍵字搜尋"
        search.returnKeyType = .done
        search.delegate = self
        return search
    }()
    
    let viewModel = HomeViewModel()
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        binding()
    }
    
    func binding() {
        viewModel.dataChangedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.refreshControl.endRefreshing()
                self?.showAlert(title: "Oops!", message: "The data couldn't be read because it is missing")
            }
            .store(in: &cancellables)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(closeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleRefreshControl() {
        viewModel.triggerLoadPageSubject.send()
    }
}

private extension HomeViewController {
    func setupUI() {
        view.backgroundColor = .white
        setupTitle()
        setupTableView()
        sizeHeaderToFit()
    }
    
    func setupTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .black
        title = "Repository Search"
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    func sizeHeaderToFit() {
        var frame = searchBar.frame
        frame.size.height = searchBar.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        searchBar.frame = frame
        tableView.tableHeaderView = searchBar
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSections(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = viewModel.cellForRowAt(indexPath) else {
            return UITableViewCell()
        }
        
        switch item {
        case .result(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultCell.self), for: indexPath) as? SearchResultCell else {
                return UITableViewCell()
            }
            
            cell.config(model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel.didSelectRowAt(indexPath) else { return }
        
        let detailViewController = DetailViewController()
        detailViewController.config(item: item)
        navigationController?.pushViewController(detailViewController, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset

        if distanceFromBottom < height {
            viewModel.triggerNextPageSubject.send()
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_: UISearchBar, textDidChange: String) {
        viewModel.keywordSubject.send(textDidChange)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.triggerLoadPageSubject.send()
        searchBar.resignFirstResponder()
    }
}
