//
//  RepoDetailAPI.swift
//  iOSEngineerCodeCheck
//
//  Created by Shingo Toyoda on 2024/04/04.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import Foundation

/// リポジトリの詳細情報を取得するAPI
struct RepoDetailRequest: APIRequest {
    typealias Response = RepoDetailResponse
    
    let repositoryName: String
    
    var path: String {
        return "repos/\(repositoryName)"
    }
    
    var method: String {
        return "GET"
    }
    
    var parameters: [String: Any]? {
        return nil
    }
}

struct RepoDetailResponse: Decodable {
    let name: String
    let description: String
    let language: String?
    let stargazersCount: Int
    let subscribersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let htmlUrl: String
    let defaultBranch: String
    let owner: Owner
    
    private enum CodingKeys: String, CodingKey {
            case name
            case description
            case language
            case stargazersCount = "stargazers_count"
            case subscribersCount = "subscribers_count"
            case forksCount = "forks_count"
            case openIssuesCount = "open_issues_count"
            case hrmlUrl = "html_url"
            case defaultBranch = "default_branch"
            case owner
        }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        language = try container.decodeIfPresent(String.self, forKey: .language)
        stargazersCount = try container.decodeIfPresent(Int.self, forKey: .stargazersCount) ?? 0
        subscribersCount = try container.decodeIfPresent(Int.self, forKey: .subscribersCount) ?? 0
        forksCount = try container.decodeIfPresent(Int.self, forKey: .forksCount) ?? 0
        openIssuesCount = try container.decodeIfPresent(Int.self, forKey: .openIssuesCount) ?? 0
        htmlUrl = try container.decodeIfPresent(String.self, forKey: .hrmlUrl) ?? ""
        defaultBranch = try container.decodeIfPresent(String.self, forKey: .defaultBranch) ?? ""
        owner = try container.decodeIfPresent(Owner.self, forKey: .owner) ?? Owner(from: decoder)
    }
    
}

struct Owner: Decodable {
    let avatarUrl: String
    let login: String
    
    private enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case login
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        avatarUrl = try container.decodeIfPresent(String.self, forKey: .avatarUrl) ?? ""
        login = try container.decodeIfPresent(String.self, forKey: .login) ?? ""
    }
    
}
