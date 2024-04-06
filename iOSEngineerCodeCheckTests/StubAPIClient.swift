//
//  AtubAPIClient.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Shin Toyo on 2024/04/06.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import Foundation
@testable import iOSEngineerCodeCheck

class StubAPIClient: APIClient {
    override func send<T>(_ request: T, completion: @escaping (Result<T.Response, Error>) -> Void) where T : APIRequest {
        // SearchRepoResponseStub.jsonの読み込み
        let bundle = Bundle(for: type(of: self))
        var url:URL?
        if request is SearchReposRequest {
            url = bundle.url(forResource: "SearchRepoResponseStub", withExtension: "json")
        }else if request is RepoDetailRequest {
            url = bundle.url(forResource: "RepoDetailResponseStub", withExtension: "json")
        }
        guard let url = url else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        // Jsonのデコード
        let data = try! Data(contentsOf: url)
        do {
            let decoder: JSONDecoder = JSONDecoder()
            let responseObject: T.Response = try decoder.decode(T.Response.self, from: data)
            completion(.success(responseObject))
        } catch {
            completion(.failure(error))
        }
    }
}

