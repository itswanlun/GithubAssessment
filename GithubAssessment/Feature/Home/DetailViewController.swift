//
//  DetailViewController.swift
//  GithubAssessment
//
//  Created by WanLun on 2024/5/25.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    lazy var containerStackView: UIStackView = {
        let stackView  = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.layoutMargins = UIEdgeInsets(top: 50, left: 16, bottom: 16, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 40
        return stackView
    }()
    
    lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var innerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        return stackView
    }()
    
    lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    lazy var countStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    lazy var startsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    lazy var watchersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    lazy var forksLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    lazy var openIssuesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        setupUI()
    }
    
    func config(item: Item) {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = item.owner.login
        
        if let url = URL(string: item.owner.icon) {
            iconImageView.setImage(url: url)
        }
        
        titleLabel.text = item.fullname
        languageLabel.text = "Written in Java \(item.language)"
        startsLabel.text = "\(item.stargazersCount) stars"
        watchersLabel.text = "\(item.watchersCount) watchers"
        forksLabel.text = "\(item.forksCount) forks"
        openIssuesLabel.text = "\(item.openIssuesCount) open issues"
    }
}

private extension DetailViewController {
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(containerStackView)
        containerStackView.addArrangedSubview(iconImageView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(innerStackView)
        
        innerStackView.addArrangedSubview(languageLabel)
        innerStackView.addArrangedSubview(countStackView)
        
        countStackView.addArrangedSubview(startsLabel)
        countStackView.addArrangedSubview(watchersLabel)
        countStackView.addArrangedSubview(forksLabel)
        countStackView.addArrangedSubview(openIssuesLabel)

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: view.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 300),
            iconImageView.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
}
