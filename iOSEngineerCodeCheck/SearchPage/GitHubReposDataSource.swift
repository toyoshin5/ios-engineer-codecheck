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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let repo: Repository = repos[indexPath.row]
        cell.bind(title: repo.fullName)
        return cell
    }
}
