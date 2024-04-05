import UIKit

class GitHubReposDataSource: NSObject, UITableViewDataSource {
    private var repos: [Repository] = []

    func update(with repos: [Repository]) {
        self.repos = repos
    }

    func repo(at index: Int) -> Repository? {
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
        let repo: Repository = repos[indexPath.row]
        cell.textLabel?.text = repo.fullName
        return cell
    }
}

struct Repository {
    let fullName: String
}
