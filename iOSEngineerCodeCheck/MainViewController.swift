//
//  MainViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var githubRepos: [[String: Any]] = []
    
    var task: URLSessionTask?
    var searchKeyword: String?
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
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
            let apiUrl: String = "https://api.github.com/search/repositories?q=\(keyword)"
            if let url = URL(string: apiUrl) {
                task = URLSession.shared.dataTask(with: url) {[weak self] (data, _, _) in
                    guard let self = self else {
                        return
                    }
                    if let data = data {
                        do {
                            if let obj = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                                if let items = obj["items"] as? [[String: Any]] {
                                    self.githubRepos = items
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                        } catch {
                            print("JSON serialization failed: \(error)")
                        }
                    } else {
                        print("Data is nil")
                    }
                }
            } else {
                print("URL is nil")
            }
        // これ呼ばなきゃAPIが叩かれない
        task?.resume()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail" {
            if let detail = segue.destination as? DetailViewController {
                detail.vc1 = self
            } else {
                print("segue.destination is nil")
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return githubRepos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell()
        let repo: [String: Any] = githubRepos[indexPath.row]
        cell.textLabel?.text = repo["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repo["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルをタップしたときに呼ばれる
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
        
    }
    
}
