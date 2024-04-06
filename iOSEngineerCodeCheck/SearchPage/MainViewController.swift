import UIKit
import Combine

class MainViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!

    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: MainViewModel = MainViewModel()
    private var dataSource: GitHubReposDataSource = GitHubReposDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = Constant.searchBarPlaceholder
        searchBar.delegate = self
        tableView.dataSource = dataSource

        viewModel.$repos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dataSource.update(with: self?.viewModel.repos ?? [])
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail",
           let detail = segue.destination as? DetailViewController,
           let repo = sender as? Repository {
            detail.viewModel.fullName = repo.fullName
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let repo = viewModel.repos[safe: indexPath.row] {
            performSegue(withIdentifier: "Detail", sender: repo)
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, !keyword.isEmpty else {
            return
        }
        viewModel.searchRepos(with: keyword)
    }
}
