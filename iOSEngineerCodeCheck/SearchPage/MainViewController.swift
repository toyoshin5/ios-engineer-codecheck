import UIKit
import Combine

class MainViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!

    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: MainViewModel = MainViewModel()
    private var dataSource: GitHubReposDataSource = GitHubReposDataSource()

    private var loadingView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    private var notFoundLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = Constant.searchBarPlaceholder
        searchBar.delegate = self
        // 検索バーの水平マージンを設定
        searchBar.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        tableView.dataSource = dataSource
        tableView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        
        viewModel.$repos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] repos in
                self?.dataSource.update(with: repos)
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        viewModel.$isSearching
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSearching in
                isSearching ? self?.loadingView.startAnimating() : self?.loadingView.stopAnimating()
            }
            .store(in: &cancellables)
        viewModel.$isShowNotFound
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isShowNotFound in
                self?.notFoundLabel.isHidden = !isShowNotFound
            }
            .store(in: &cancellables)
        viewModel.$isShowAlert
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isShowAlert in
                if let self = self, isShowAlert {
                    Alert.show(vc: self, title: Constant.errorTitle, message: Constant.errorMessage)
                }
            }
            .store(in: &cancellables)
        setUpLabel()
        setUpLoadingView()
    }
    
    private func setUpLabel() {
        notFoundLabel.text = Constant.repoNotFound
        notFoundLabel.frame = CGRect(x: 0, y: 100, width: tableView.bounds.width, height: 20)
        notFoundLabel.textAlignment = .center
        notFoundLabel.textColor = .systemGray
        notFoundLabel.font = .systemFont(ofSize: 20)
        tableView.addSubview(notFoundLabel)
    }
    
    private func setUpLoadingView() {
        loadingView.center = CGPoint(x: tableView.bounds.midX, y: 100)
        loadingView.hidesWhenStopped = true
        tableView.addSubview(loadingView)
    }
}

// MARK: - UITableViewのデリゲートメソッド
extension MainViewController {
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

// MARK: - UISearchBarのデリゲートメソッド
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, !keyword.isEmpty else {
            return
        }
        searchBar.endEditing(true)
        viewModel.searchRepos(with: keyword)
    }
}
