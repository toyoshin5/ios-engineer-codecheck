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

}

struct RepoItem: Decodable {
    let fullName: String
    
    private enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
    }
}
