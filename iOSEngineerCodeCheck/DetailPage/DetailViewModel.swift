//
//  DetailViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Shingo Toyoda on 2024/04/06.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import UIKit
import Combine

class DetailViewModel: ObservableObject {
    @Published var repository: RepositoryDetail?
    @Published var avatarImage: UIImage?
    @Published var readmeText: String?
    
    var fullName: String = ""
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func fetchDetail() {
        let apiClient: APIClient = APIClient(baseURL: URL(string: Constant.githubAPIURL)!)
        let request: RepoDetailRequest = RepoDetailRequest(repositoryName: fullName)
        
        apiClient.send(request, completion: { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let response):
                self.repository = RepositoryDetail(
                    title: response.name,
                    owner: response.owner.login,
                    language: response.language,
                    description: response.description,
                    stars: response.stargazersCount,
                    watchers: response.subscribersCount,
                    forks: response.forksCount,
                    issues: response.openIssuesCount,
                    htmlUrl: response.htmlUrl
                )
                self.fetchRepoImage(of: response.owner.avatarUrl)
                self.fetchReadme(branch: response.defaultBranch)
            case .failure(let error):
                print(error)
            }
        })
    
    }
    
    private func fetchRepoImage(of imgURL: String) {
        ImageFetcher.shared.fetch(from: imgURL, completion: { [weak self] image in
            self?.avatarImage = image
        })
    }
    
    private func fetchReadme(branch: String) {
        GitHubReadmeFetcher.shared.fetchReadme(fullName: self.fullName, branch: branch, completion: { [weak self] readme in
            if readme?.isEmpty ?? true {
                self?.readmeText = "README not found"
            } else {
                self?.readmeText = readme
            }
        })
    }
    
    func getPreliminalTitle() -> String {
        return self.fullName.split(separator: "/").last.map(String.init) ?? ""
    }
    
    func openWithBrowser() {
        guard let url = URL(string: repository?.htmlUrl ?? "") else {
            return
        }
        UIApplication.shared.open(url)
    }
}
