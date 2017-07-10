//
//  ForgotPasswordUITests.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-07-03.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import XCTest

class ForgotPasswordUITests: XCTestCase {

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

    func testForgotPassword() {
     
        
        let app = XCUIApplication()
        app.buttons[ControllerConstants.TestKeys.forgotPassword].tap()
        
        let textField = app.textFields[ControllerConstants.TestKeys.email]
        textField.tap()
        textField.typeText(ControllerConstants.TestKeys.TestAccount.emailId)
        app.buttons[ControllerConstants.TestKeys.reset].tap()
        
        sleep(3)
        
        let alert = app.alerts[ControllerConstants.TestKeys.emailSent].buttons[ControllerConstants.TestKeys.ok]
        XCTAssertTrue(alert.exists)
    }
    
}
