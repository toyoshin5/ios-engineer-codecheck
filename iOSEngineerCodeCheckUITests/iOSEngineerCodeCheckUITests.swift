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
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.tables["Empty list"].searchFields["GitHubのリポジトリを検索できるよー"].tap()
        app.tables["Empty list"].searchFields["GitHubのリポジトリを検索できるよー"].typeText("swift\n")
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["apple/swift"]/*[[".cells.staticTexts[\"apple\/swift\"]",".staticTexts[\"apple\/swift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        //文字が表示されるか
        XCTAssert(app.staticTexts["apple/swift"].exists)
        app.navigationBars["iOSEngineerCodeCheck.DetailView"].buttons["Root View Controller"].tap()
        app.tables.staticTexts["realm/SwiftLint"].tap()
        //文字が表示されるか
        XCTAssert(app.staticTexts["realm/SwiftLint"].exists)
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
