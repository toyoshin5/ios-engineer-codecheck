//
//  MainViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    private var dataSource: GitHubReposDataSource = GitHubReposDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
        tableView.dataSource = dataSource
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            if let detail = segue.destination as? DetailViewController,
               // RepoItemはsenderから受け取るほうが安全
               let repo = sender as? Repository {
                detail.fullName = repo.fullName
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルをタップしたときに呼ばれる
        if let repo = dataSource.repo(at: indexPath.row) {
            performSegue(withIdentifier: "Detail", sender: repo)
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, !keyword.isEmpty else {
            return
        }
        if !keyword.isEmpty {
            let apiClient: APIClient = APIClient(baseURL: URL(string: Constant.githubAPIURL)!)
            let request: SearchReposRequest = SearchReposRequest(keyword: keyword)
            apiClient.send(request) {[weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let response):
                    let repos: [Repository] = response.items.map { Repository(fullName: $0.fullName) }
                    DispatchQueue.main.async {
                        self.dataSource.update(with: repos)
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

}
