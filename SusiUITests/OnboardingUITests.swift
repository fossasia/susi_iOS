//
//  OnboardingUITests.swift
//  SusiUITests
//
//  Created by JOGENDRA on 17/05/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import XCTest

class OnboardingUITests: XCTestCase {

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
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGoingThroughOnboarding() {
        // Swipe left three times to go through the pages
        app.swipeLeft()
        app.swipeLeft()
        app.swipeLeft()

        // Tap the "Skip" button
        app.buttons["Login/Skip"].tap()
    }
}
