//
//  AlertUtil.swift
//  iOSEngineerCodeCheck
//
//  Created by Shingo Toyoda on 2024/04/09.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import UIKit

final class Alert {
    static func show(vc: UIViewController, title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let okAlertVC: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        okAlertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        vc.present(okAlertVC, animated: true, completion: nil)
    }
}
