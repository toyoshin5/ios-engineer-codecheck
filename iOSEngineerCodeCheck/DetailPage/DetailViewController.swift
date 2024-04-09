//
//  DetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by Shingo Toyoda on 2024/04/06.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import UIKit
import Combine
import MarkdownView

class DetailViewController: UIViewController {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var readmeView: MarkdownView!
    
    @IBOutlet weak var readmeViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var entireContentView: UIView!
    
    var loadingView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    var viewModel: DetailViewModel = DetailViewModel()
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.getPreliminalTitle()
        
        viewModel.$repository
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] repository in
                guard let self = self, let repository = repository else {
                    return
                }
                self.navigationItem.title = repository.title
                self.descriptionLabel.text = repository.description
                self.ownerLabel.text = repository.owner
                self.languageLabel.text = repository.language
                self.starsLabel.text = "\(repository.stars) stars"
                self.watchersLabel.text = "\(repository.watchers) watchers"
                self.forksLabel.text = "\(repository.forks) forks"
                self.issuesLabel.text = "\(repository.issues) open issues"
            })
            .store(in: &cancellables)
        viewModel.$avatarImage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] image in
                self?.imgView.image = image
            })
            .store(in: &cancellables)
        viewModel.$readmeText
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] readme in
                self?.readmeView.load(markdown: readme)
            
            })
            .store(in: &cancellables)
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                if isLoading {
                    self?.loadingView.startAnimating()
                    self?.entireContentView.isHidden = true
                } else {
                    self?.loadingView.stopAnimating()
                    self?.entireContentView.isHidden = false
                }
            })
            .store(in: &cancellables)
        
        viewModel.fetchDetail()
        
        setUpLoadingView()
        setUpReadmeView()
        
    }
    
    private func setUpLoadingView() {
        loadingView.center = view.center
        loadingView.hidesWhenStopped = true
        view.addSubview(loadingView)
    }
    
    func setUpReadmeView() {
        readmeView.isScrollEnabled = false
        readmeView.onRendered = { [weak self] height in
            self?.readmeViewHeight.constant = height
            self?.view.setNeedsLayout()
        }
    }
    
    @IBAction func onTapOpenBrowser(_ sender: Any) {
        viewModel.openWithBrowser()
    }
}
