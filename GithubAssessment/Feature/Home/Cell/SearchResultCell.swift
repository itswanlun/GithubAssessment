//
//  SearchResultCell.swift
//  GithubAssessment
//
//  Created by WanLun on 2024/5/24.
//

import Foundation
import UIKit

class SearchResultCell: UITableViewCell {
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "figure.walk.circle.fill")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var innerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var innerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "apple/swift"
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The Swift Programming Language The Swift Programming Language "
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SearchResultCell {
    func setupUI() {
        contentView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(iconImageView)
        containerStackView.addArrangedSubview(innerView)
        innerView.addSubview(innerStackView)
        innerStackView.addArrangedSubview(titleLabel)
        innerStackView.addArrangedSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            innerStackView.topAnchor.constraint(greaterThanOrEqualTo: innerView.topAnchor),
            innerStackView.bottomAnchor.constraint(lessThanOrEqualTo: innerView.bottomAnchor),
            innerStackView.leadingAnchor.constraint(equalTo: innerView.leadingAnchor),
            innerStackView.trailingAnchor.constraint(equalTo: innerView.trailingAnchor),
            innerStackView.centerYAnchor.constraint(equalTo: innerView.centerYAnchor)
        ])
        
        let heightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 80)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            heightConstraint
        ])
    }
}
