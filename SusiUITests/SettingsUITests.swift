//
//  SettingsUITests.swift
//  SusiUITests
//
//  Created by JOGENDRA on 20/05/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import XCTest

class SettingsUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.
        app.launchArguments += ["UI-Testing"]

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.swipeLeft()
        app.swipeLeft()
        app.swipeLeft()
        app.buttons["Login/Skip"].tap()
        app.buttons["Skip"].tap()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSettingsButton() {
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 0).tap()
        app.navigationBars["Susi.SettingsView"].buttons["cm arrow back white"].tap()
    }

}
