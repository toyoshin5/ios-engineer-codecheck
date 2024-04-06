//
//  DetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by Shingo Toyoda on 2024/04/06.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    
    var viewModel: DetailViewModel = DetailViewModel()
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = viewModel.fullName
        viewModel.$repository
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] repository in
                guard let self = self, let repository = repository else {
                    return
                }
                self.languageLabel.text = "Written in \(repository.language)"
                self.starsLabel.text = "\(repository.stars) stars"
                self.watchersLabel.text = "\(repository.watchers) watchers"
                self.forksLabel.text = "\(repository.forks) forks"
                self.issuesLabel.text = "\(repository.issues) open issues"
            })
            .store(in: &cancellables)
        viewModel.$image
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] image in
                self?.imgView.image = image
            })
            .store(in: &cancellables)
        
        viewModel.fetchDetail()
    }
}
