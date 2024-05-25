//
//  Response.swift
//  GithubAssessment
//
//  Created by WanLun on 2024/5/25.
//

import Foundation

struct Repositories: Codable {
    let items: [Item]?
}

struct Item: Codable {
    let fullname: String
    let description: String?
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let owner: Owner
    
    
    enum CodingKeys: String, CodingKey {
        case fullname = "full_name"
        case description
        case language
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues"
        case owner
    }
}

struct Owner: Codable {
    let icon: String
    let login: String
    
    enum CodingKeys: String, CodingKey {
        case icon = "avatar_url"
        case login
    }
}
