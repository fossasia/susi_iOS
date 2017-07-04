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
        
        AuthenticationUITests.init().testLoginSuccess()
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
        
        let collectionViewsQuery = app.collectionViews
        
        let incomingMessage = collectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .textView).element
        XCTAssertTrue(incomingMessage.exists)
        
    }
    
    func testMapAndAnchor() {
        
        let inputviewTextView = XCUIApplication().textViews[ControllerConstants.TestKeys.chatInputView]
        inputviewTextView.tap()
        inputviewTextView.typeText("Where IS Singapore?")
        app.buttons[ControllerConstants.TestKeys.send].tap()
        
        sleep(5)
        
        let collectionViewsQuery = app.collectionViews
        let mapViewCell = collectionViewsQuery.children(matching: .cell).element(boundBy: 3).children(matching: .other).element(boundBy: 0)
        XCTAssertTrue(mapViewCell.exists)
        
    }
    
    func testRSSAction() {
        
        let inputviewTextView = app.textViews[ControllerConstants.TestKeys.chatInputView]
        inputviewTextView.tap()
        inputviewTextView.typeText("Amazon")
        app.buttons[ControllerConstants.TestKeys.send].tap()
        
        sleep(5)
        
        let collectionView = app.collectionViews.collectionViews[ControllerConstants.TestKeys.rssCollectionView]
        XCTAssertTrue(collectionView.exists)
        
    }
    
}
