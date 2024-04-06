import Combine
import Foundation

class MainViewModel: ObservableObject {
    @Published var repos: [Repository] = []

    private let apiClient: APIClient = APIClient(baseURL: URL(string: Constant.githubAPIURL)!)

    func searchRepos(with keyword: String) {
        let request: SearchReposRequest = SearchReposRequest(keyword: keyword)
        apiClient.send(request) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let response):
                let repos: [Repository] = response.items.map { Repository(fullName: $0.fullName) }
                DispatchQueue.main.async {
                    self.repos = repos
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
