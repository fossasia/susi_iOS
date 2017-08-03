//
//  ChatUITests.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-07-03.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import XCTest

class ChatUITests: XCTestCase {

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
        app.buttons[ControllerConstants.TestKeys.skip].tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAnswerAction() {
        let inputviewTextView = app.textViews[ControllerConstants.TestKeys.chatInputView]
        inputviewTextView.tap()
        inputviewTextView.typeText("Hi there")
        
        let sendButton = app.buttons[ControllerConstants.TestKeys.send]
        sendButton.tap()
        
        sleep(5)
        
        let chatCells = app.collectionViews.cells.matching(identifier: ControllerConstants.TestKeys.chatCells)
        XCTAssertEqual(chatCells.count, 2)
    }
    
    func testRSSAction() {
        let inputviewTextView = app.textViews[ControllerConstants.TestKeys.chatInputView]
        inputviewTextView.tap()
        inputviewTextView.typeText("Amazon")
        app.buttons[ControllerConstants.TestKeys.send].tap()
        
        sleep(5)
        
        let chatCells = app.collectionViews.cells.matching(identifier: ControllerConstants.TestKeys.chatCells)
        XCTAssertEqual(chatCells.count, 3)
    }
    
}
