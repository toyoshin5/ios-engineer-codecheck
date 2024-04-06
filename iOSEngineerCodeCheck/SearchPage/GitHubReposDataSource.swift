import UIKit

class GitHubReposDataSource: NSObject, UITableViewDataSource {
    private var repos: [Repository] = []

    func update(with repos: [Repository]) {
        self.repos = repos
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        let repo: Repository = repos[indexPath.row]
        cell.textLabel?.text = repo.fullName
        return cell
    }
}
