//
//  Constant.swift
//  iOSEngineerCodeCheck
//
//  Created by Shingo Toyoda on 2024/04/05.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

// 定数を管理するクラス
class Constant {
    static let githubAPIURL: String = "https://api.github.com"
    static let githubContentAPIURL: String = "https://raw.githubusercontent.com/"
    static let searchBarPlaceholder: String = "GitHubのリポジトリを検索できるよー"
    static let repoNotFound: String = "Repository not found"
    static let noReadmeText: String = "README file not found"
    static let errorTitle: String = "Error"
    static let errorMessage: String = "Failed to get repositories.\nPlease try again later."
}
