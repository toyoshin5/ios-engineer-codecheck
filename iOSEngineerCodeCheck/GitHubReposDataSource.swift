import UIKit

class GitHubReposDataSource: NSObject, UITableViewDataSource {
    private var repos: [RepoItem] = []

    func update(with repos: [RepoItem]) {
        self.repos = repos
    }

    func repo(at index: Int) -> RepoItem? {
        guard index >= 0 && index < repos.count else {
            return nil
        }
        return repos[index]
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        let repo: RepoItem = repos[indexPath.row]
        cell.textLabel?.text = repo.fullName
        return cell
    }
}
