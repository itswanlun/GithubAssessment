//
//  ViewController.swift
//  GithubAssessment
//
//  Created by WanLun on 2024/5/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: String(describing: SearchResultCell.self))
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.searchBarStyle = UISearchBar.Style.default
        search.placeholder = "請輸入關鍵字搜尋"
        search.returnKeyType = .done
        return search
    }()
    
    let viewModel = HomeViewModel()
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        binding()
        viewModel.loadData(q: "swift", page: 1)
    }
    
    func binding() {
        viewModel.dataChangedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
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
extension HomeViewController: UITableViewDataSource {
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
}
