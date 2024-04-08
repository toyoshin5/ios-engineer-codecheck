//
//  SearchRepoAPI.swift
//  iOSEngineerCodeCheck
//
//  Created by Shingo Toyoda on 2024/04/04.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import Foundation

/// リポジトリの検索結果を取得するAPI
struct SearchReposRequest: APIRequest {
    typealias Response = SearchReposResponse
    
    let keyword: String
    
    var path: String {
        return "search/repositories"
    }
    
    var method: String {
        return "GET"
    }
    
    var parameters: [String: Any]? {
        return ["q": keyword]
    }
}

struct SearchReposResponse: Decodable {
    let items: [RepoItem]
    
    private enum CodingKeys: String, CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decodeIfPresent([RepoItem].self, forKey: .items) ?? []
    }

}

struct RepoItem: Decodable {
    let name: String
    let fullName: String
    let description: String
    let owner: Owner
    
    private enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
        case description
        case owner
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        fullName = try container.decodeIfPresent(String.self, forKey: .fullName) ?? ""
        description = try
            container
            .decodeIfPresent(String.self, forKey: .description) ?? ""
        owner = try container.decodeIfPresent(Owner.self, forKey: .owner) ?? Owner(from: decoder)
    }
}
