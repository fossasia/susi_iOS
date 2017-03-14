//
//  SignUpViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class SignUpViewController: UIViewController {

    // Setup Dismiss Button
    let dismissButton: IconButton = {
        let ib = IconButton()
        ib.image = Icon.cm.arrowBack
        ib.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        ib.tintColor = .white
        return ib
    }()
    
    // Setup Email Field
    lazy var emailField: ErrorTextField = {
        let textField = ErrorTextField()
        textField.keyboardType = .emailAddress
        textField.placeholder = "Email Address"
        textField.detail = "Error, incorrect email"
        textField.detailColor = .red
        textField.isClearIconButtonEnabled = true
        textField.placeholderNormalColor = .white
        textField.placeholderActiveColor = .white
        textField.dividerNormalColor = .white
        textField.dividerActiveColor = .white
        textField.textColor = .white
        textField.clearIconButton?.tintColor = .white
        textField.isErrorRevealed = false
        return textField
    }()
    
    // Setup Password Field
    let passwordField: TextField = {
        let textField = TextField()
        textField.placeholder = "Password"
        textField.detail = "At least 8 characters"
        textField.placeholderNormalColor = .white
        textField.placeholderActiveColor = .white
        textField.dividerNormalColor = .white
        textField.dividerActiveColor = .white
        textField.detailColor = .white
        textField.textColor = .white
        textField.clearIconButton?.tintColor = .white
        textField.clearButtonMode = .whileEditing
        textField.isVisibilityIconButtonEnabled = true
        textField.visibilityIconButton?.tintColor = Color.white.withAlphaComponent(textField.isSecureTextEntry ? 0.38 : 0.54)
        return textField
    }()
    
    // Setup Confirm Password Field
    let confirmPasswordField: TextField = {
        let textField = TextField()
        textField.placeholder = "Confirm Password"
        textField.placeholderNormalColor = .white
        textField.placeholderActiveColor = .white
        textField.dividerNormalColor = .white
        textField.dividerActiveColor = .white
        textField.detailColor = .white
        textField.textColor = .white
        textField.clearIconButton?.tintColor = .white
        textField.clearButtonMode = .whileEditing
        textField.isVisibilityIconButtonEnabled = true
        textField.visibilityIconButton?.tintColor = Color.white.withAlphaComponent(textField.isSecureTextEntry ? 0.38 : 0.54)
        return textField
    }()
    
    // Setup Sign Up Button
    lazy var signUpButton: RaisedButton = {
        let button = RaisedButton()
        button.setTitle("SIGN UP", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.defaultColor(), for: .normal)
        button.addTarget(self, action: #selector(performSignUp), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.defaultColor()
        
        prepareDismissButton()
        prepareEmailField()
        preparePasswordField()
        prepareConfirmPasswordField()
        prepareSignUpButton()
    }
    
    // Add Subview Dismiss Button
    func prepareDismissButton() {
        self.view.addSubview(dismissButton)
        self.view.layout(dismissButton).topLeft(top: 20, left: 8)
    }
    
    // Dismiss View Controller
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Add Subview Email Field
    private func prepareEmailField() {
        self.view.addSubview(emailField)
        self.view.layout(emailField).top(100).left(20).right(20)
    }
    
    // Add Subview Password Field
    private func preparePasswordField() {
        self.view.addSubview(passwordField)
        self.view.layout(passwordField).top(165).left(20).right(20)
    }
    
    // Add Subview Confirm Password Field
    private func prepareConfirmPasswordField() {
        self.view.addSubview(confirmPasswordField)
        self.view.layout(confirmPasswordField).top(250).left(20).right(20)
    }
    
    // Add Subview Sign Up Button
    private func prepareSignUpButton() {
        self.view.addSubview(signUpButton)
        self.view.layout(signUpButton).height(44).top(300).left(20).right(20)
    }
    
    // Sign Up User
    func performSignUp() {
        
        toggleEditing()
        
        let params = [
            Client.UserKeys.SignUp: emailField.text?.lowercased(),
            Client.UserKeys.Password: passwordField.text
        ]
        
        Client.sharedInstance.registerUser(params as [String : AnyObject]) { (success, message) in
            DispatchQueue.main.async {
                self.toggleEditing()
                if success {
                    self.dismissView()
                }
                self.view.makeToast(message)
            }
        }
    }
    
    func toggleEditing() {
        emailField.isEnabled = !emailField.isEnabled
        passwordField.isEnabled = !passwordField.isEnabled
        confirmPasswordField.isEnabled = !confirmPasswordField.isEnabled
        signUpButton.isEnabled = !signUpButton.isEnabled
    }

}
