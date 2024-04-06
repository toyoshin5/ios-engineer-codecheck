//
//  ImageFetcher.swift
//  iOSEngineerCodeCheck
//
//  Created by Shigon Toyoda on 2024/04/06.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import UIKit

class ImageFetcher {
    static let shared: ImageFetcher = ImageFetcher() // シングルトン
    
    private init() {}
    
    func fetch(from imgURL: String, completion: @escaping (UIImage?) -> Void) {
        if let url = URL(string: imgURL) {
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }.resume()
        } else {
            completion(nil)
        }
    }
}
