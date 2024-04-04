//
//  APIRequest.swift
//  iOSEngineerCodeCheck
//
//  Created by Shingo Toyoda on 2024/04/04.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import Foundation

/// APIリクエストのプロトコル
protocol APIRequest {
    associatedtype Response: Decodable
    
    var path: String { get }
    var method: String { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

extension APIRequest {
    var headers: [String: String]? {
        return nil
    }
}
