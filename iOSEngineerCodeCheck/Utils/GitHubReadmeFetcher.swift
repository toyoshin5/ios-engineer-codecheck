//
//  GitHubReadmeFetcher.swift
//  iOSEngineerCodeCheck
//
//  Created by Shin Toyo on 2024/04/09.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import Foundation
class GitHubReadmeFetcher {
    static let shared: GitHubReadmeFetcher = GitHubReadmeFetcher()
    
    static let baseURL: String = "https://raw.githubusercontent.com/"
    
    private init() {}
    
    func fetchReadme(fullName: String, branch: String, completion: @escaping (String?) -> Void) {
        if let url: URL = URL(string: GitHubReadmeFetcher.baseURL + fullName + "/" + branch + "/README.md") {
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                if let data = data, let readme: String = String(data: data, encoding: .utf8) {
                    completion(readme)
                } else {
                    completion(nil)
                }
            }.resume()
        } else {
            completion(nil)
        }
    }
}
