//
//  DetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var starsLbl: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    
    var vc1: MainViewController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let vc1 = vc1, let selectedIndex = vc1.selectedIndex, let repo = vc1.githubRepos[safe: selectedIndex] else {
            return
        }
        
        languageLabel.text = "Written in \(repo["language"] as? String ?? "")"
        starsLbl.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text = "\(repo["wachers_count"] as? Int ?? 0) watchers"
        forksLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        issuesLabel.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        fetchAndDisplayRepoImage()
        
    }
    
    func fetchAndDisplayRepoImage() {
        
        guard let vc1 = vc1, let selectedIndex = vc1.selectedIndex, let repo = vc1.githubRepos[safe: selectedIndex] else {
            return
        }
        
        titleLabel.text = repo["full_name"] as? String
        
        if let owner = repo["owner"] as? [String: Any] {
            if let imgURL = owner["avatar_url"] as? String {
                if let url = URL(string: imgURL) {
                    URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
                        guard let self = self else {
                            return
                        }
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.imgView.image = image
                            }
                        }
                    }.resume()

                }
            }
        }
        
    }
    
}
