//
//  TableViewCell.swift
//  iOSEngineerCodeCheck
//
//  Created by Shin Toyo on 2024/04/08.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    static let reuseIdentifier: String = "TableViewCell"
    
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var ownerImgView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: TableViewCell.reuseIdentifier, bundle: nil)
    }

    func bind(repo: Repository) {
        self.title.text = repo.title
        self.owner.text = repo.owner
        self.descriptionLabel.text = repo.description
        self.starsLabel.text = "\(repo.stars)"
        self.fetchRepoImage(of: repo.avatarUrl)
    }
    
    private func fetchRepoImage(of imgURL: String) {
        ImageFetcher.shared.fetch(from: imgURL, completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.ownerImgView.image = image
            }
        })
    }
    
}
