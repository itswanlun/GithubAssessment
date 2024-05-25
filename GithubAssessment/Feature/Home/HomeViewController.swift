//
//  ViewController.swift
//  GithubAssessment
//
//  Created by WanLun on 2024/5/24.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        binding()
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
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultCell.self), for: indexPath) as? SearchResultCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
}
