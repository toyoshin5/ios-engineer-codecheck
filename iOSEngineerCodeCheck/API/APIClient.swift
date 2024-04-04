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
    
    private func addQueryParameters(to url: URL, parameters: [String: Any]) -> URL? {
        var components: URLComponents? = URLComponents(url: url, resolvingAgainstBaseURL: true)
        var queryItems: [URLQueryItem] = []
        for (key, value) in parameters {
            let stringValue: String = String(describing: value)
            queryItems.append(URLQueryItem(name: key, value: stringValue))
        }
        components?.queryItems = queryItems
        return components?.url
    }

    func send<T: APIRequest>(_ request: T, completion: @escaping (Result<T.Response, Error>) -> Void) {
        
        let url: URL = baseURL.appendingPathComponent(request.path)
        guard let url: URL = addQueryParameters(to: url, parameters: request.parameters ?? [:]) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        urlRequest.allHTTPHeaderFields = request.headers
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
