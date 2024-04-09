//
//  iOSEngineerCodeCheckUITests.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest

class iOSEngineerCodeCheckUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        app.tables["Empty list"].searchFields["GitHubのリポジトリを検索できるよー"].tap()
        app.tables["Empty list"].searchFields["GitHubのリポジトリを検索できるよー"].typeText("swift\n")
        app.tables.staticTexts["SwiftLint"].tap()
        //文字が表示されるか
        XCTAssert(app.staticTexts["realm"].exists)
        app.navigationBars["SwiftLint"].buttons["GitHub Search"].tap()
    }
}
