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
    
    var fullName: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = fullName
        fetchDetailFromName(of: fullName)
        
    }
    
    func fetchDetailFromName(of name: String?) {
        guard let name = name else {
            return
        }
        let apiClient: APIClient = APIClient(baseURL: URL(string: "https://api.github.com")!)
        let request: RepoDetailRequest = RepoDetailRequest(repositoryName: name)
        apiClient.send(request) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.languageLabel.text = "Written in \(response.language)"
                    self.starsLbl.text = "\(response.stargazersCount) stars"
                    self.watchersLabel.text = "\(response.subscribersCount) watchers"
                    self.forksLabel.text = "\(response.forksCount) forks"
                    self.issuesLabel.text = "\(response.openIssuesCount) open issues"
                }
                self.fetchAndDisplayRepoImage(of: response.owner.avatarUrl)
            case .failure(let error):
                print("APIError: \(error)")
            }
        }
    }
    
    func fetchAndDisplayRepoImage(of imgURL: String) {
    
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
