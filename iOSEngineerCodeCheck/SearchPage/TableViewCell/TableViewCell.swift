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
    
    @IBOutlet weak var title: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: TableViewCell.reuseIdentifier, bundle: nil)
    }

    func bind(title: String) {
        self.title.text = title
    }
}
