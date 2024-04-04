//
//  APIClient.swift
//  iOSEngineerCodeCheck
//
//  Created by Shingo Toyoda on 2024/04/04.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import Foundation

/// APIクライアント
class APIClient {
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func send<T: APIRequest>(_ request: T, completion: @escaping (Result<T.Response, Error>) -> Void) {
        let url: URL = baseURL.appendingPathComponent(request.path)
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        urlRequest.allHTTPHeaderFields = request.headers
        if request.method == "POST" {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: request.parameters ?? [:])
        }
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data else {
                completion(.failure(error ?? NSError(domain: "Unknown", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decoder: JSONDecoder = JSONDecoder()
                let responseObject: T.Response = try decoder.decode(T.Response.self, from: data)
                completion(.success(responseObject))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
