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
    
    var githubRepos: SearchReposResponse = SearchReposResponse(items: [])
    var task: URLSessionTask?
    var searchKeyword: String?
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail" {
            if let detail = segue.destination as? DetailViewController {
                if let selectedIndex = selectedIndex {
                    detail.fullName = githubRepos.items[safe: selectedIndex]?.fullName ?? ""
                }
            } else {
                print("segue.destination is nil")
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return githubRepos.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell()
        if let repo: RepoItem = githubRepos.items[safe: indexPath.row] {
            cell.textLabel?.text = repo.fullName
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルをタップしたときに呼ばれる
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
        
    }
    
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchKeyword = searchBar.text
        guard let keyword = searchKeyword else {
            return
        }
        if !keyword.isEmpty {
            let apiClient: APIClient = APIClient(baseURL: URL(string: Constant.githubAPIURL)!)
            let request: SearchReposRequest = SearchReposRequest(keyword: keyword)
            apiClient.send(request) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.githubRepos = response
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        // これ呼ばなきゃAPIが叩かれない
        task?.resume()
        }
    }

}

