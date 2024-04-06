//
//  iOSEngineerCodeCheckTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class iOSEngineerCodeCheckTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchRepoStub() {
        let apiClient = StubAPIClient(baseURL: URL(string: Constant.githubAPIURL)!)
        let request = SearchReposRequest(keyword: "")
        apiClient.send(request) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.items.count, 1)
                XCTAssertEqual(response.items.first?.fullName, "apple/swift")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testRepoDetailStub() {
        let apiClient = StubAPIClient(baseURL: URL(string: Constant.githubAPIURL)!)
        let request = RepoDetailRequest(repositoryName: "")
        apiClient.send(request) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.stargazersCount, 65750)
                XCTAssertEqual(response.subscribersCount, 2489)
                XCTAssertEqual(response.forksCount, 10184)
                XCTAssertEqual(response.language, "C++")
                XCTAssertEqual(response.openIssuesCount, 7227)
                XCTAssertEqual(response.owner.avatarUrl, "https://avatars.githubusercontent.com/u/10639145?v=4")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
}
