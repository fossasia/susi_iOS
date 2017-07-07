//
//  SusiUITests.swift
//  SusiUITests
//
//  Created by Chashmeet Singh on 2017-04-26.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import XCTest

class AuthenticationUITests: XCTestCase {
    
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

    func testLoginSuccess() {
        
        let scrollViewsQuery = app.scrollViews
        
        let emailField = scrollViewsQuery.textFields[ControllerConstants.TestKeys.email]
        emailField.tap()
        emailField.typeText(ControllerConstants.TestKeys.TestAccount.emailId)
        app.buttons[ControllerConstants.TestKeys.returnHit].tap()
        
        let secureTextField = scrollViewsQuery.secureTextFields[ControllerConstants.TestKeys.password]
        secureTextField.tap()
        secureTextField.typeText(ControllerConstants.TestKeys.TestAccount.password)
        
        app.buttons[ControllerConstants.TestKeys.login].tap()
        
        sleep(3)
        
        let sendButton = app.buttons[ControllerConstants.TestKeys.send]
        XCTAssertTrue(sendButton.exists)
        
    }
    
    func testLoginFailure() {
        
        let scrollViewsQuery = app.scrollViews
        
        let emailField = scrollViewsQuery.textFields[ControllerConstants.TestKeys.email]
        emailField.tap()
        emailField.typeText(ControllerConstants.TestKeys.TestAccount.emailId)
        app.buttons[ControllerConstants.TestKeys.returnHit].tap()
        
        let secureTextField = scrollViewsQuery.secureTextFields[ControllerConstants.TestKeys.password]
        secureTextField.tap()
        secureTextField.typeText(ControllerConstants.TestKeys.TestAccount.incorrectPassword)
        
        app.buttons[ControllerConstants.TestKeys.login].tap()
        
        sleep(2)
        
        let toast = app.staticTexts[ControllerConstants.TestKeys.incorrectLogin]
        XCTAssertTrue(toast.exists)
        
    }
    
    func testLogoutSuccess() {
        
        testLoginSuccess()
        
        let button = app.navigationBars["Susi.MainView"].children(matching: .other).element(boundBy: 0).children(matching: .button).element(boundBy: 1)
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView).element.tap()
        button.tap()
        app.tables.staticTexts[ControllerConstants.TestKeys.logout].tap()
        
        let loginButton = app.buttons[ControllerConstants.TestKeys.login]
        XCTAssertTrue(loginButton.exists)
        
    }
    
    func testSignUpFailure() {
        
        app.buttons["Sign up for SUSI"].tap()
        
        let emailTextField = app.textFields[ControllerConstants.TestKeys.email]
        emailTextField.tap()
        emailTextField.typeText(ControllerConstants.TestKeys.TestAccount.emailId)
        
        let passwordTextField = app.secureTextFields[ControllerConstants.TestKeys.password]
        passwordTextField.tap()
        passwordTextField.typeText(ControllerConstants.TestKeys.TestAccount.password)
        
        let confirmpasswordTextField = app.secureTextFields[ControllerConstants.TestKeys.confirmPassword]
        confirmpasswordTextField.tap()
        confirmpasswordTextField.typeText(ControllerConstants.TestKeys.TestAccount.password)
        
        app.buttons["signUp"].tap()
        
        sleep(2)
        
        let toast = app.staticTexts[Client.ResponseMessages.ServerError]
        XCTAssertTrue(toast.exists)
        
    }

}
