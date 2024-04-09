import Combine
import Foundation

class MainViewModel: ObservableObject {
    @Published var repos: [Repository] = []
    @Published var isSearching: Bool = false
    @Published var isShowNotFound: Bool = false
    @Published var isShowAlert: Bool = false
    
    private let apiClient: APIClient = APIClient(baseURL: URL(string: Constant.githubAPIURL)!)

    func searchRepos(with keyword: String) {
        isSearching = true
        isShowNotFound = false
        repos = []
        let request: SearchReposRequest = SearchReposRequest(keyword: keyword)
        apiClient.send(request) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let response):
                let repos: [Repository] = response.items.map {
                    Repository(
                        fullName: $0.fullName,
                        title: $0.name,
                        owner: $0.owner.login,
                        description: $0.description,
                        stars: $0.stargazersCount,
                        avatarUrl: $0.owner.avatarUrl
                    )
                }
                isShowNotFound = repos.isEmpty
                DispatchQueue.main.async {
                    self.repos = repos
                }
            case .failure(let error):
                print(error)
                isShowNotFound = true
                isShowAlert = true
                
            }
            isSearching = false
        }
    }
    
    func showAlert() {
    }
}
