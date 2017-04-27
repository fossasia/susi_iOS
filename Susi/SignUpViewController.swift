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
    lazy var emailField: AuthTextField = {
        let textField = AuthTextField()
        textField.keyboardType = .emailAddress
        textField.placeholder = "Email Address"
        textField.detail = "Error, incorrect email"
        return textField
    }()
    
    // Setup Password Field
    lazy var passwordField: AuthTextField = {
        let textField = AuthTextField()
        textField.placeholder = "Password"
        textField.detailLabel.text = "Password should be 6 characters long with one uppercase, lowercase and a number"
        textField.clearButtonMode = .whileEditing
        textField.isVisibilityIconButtonEnabled = true
        textField.visibilityIconButton?.tintColor = Color.white.withAlphaComponent(textField.isSecureTextEntry ? 0.38 : 0.54)
        textField.delegate = self
        return textField
    }()
    
    // Setup Confirm Password Field
    lazy var confirmPasswordField: AuthTextField = {
        let textField = AuthTextField()
        textField.placeholder = "Confirm Password"
        textField.detail = "Passwords do not match"
        textField.clearIconButton?.tintColor = .white
        textField.clearButtonMode = .whileEditing
        textField.isVisibilityIconButtonEnabled = true
        textField.visibilityIconButton?.tintColor = Color.white.withAlphaComponent(textField.isSecureTextEntry ? 0.38 : 0.54)
        textField.delegate = self
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
        self.view.layout(passwordField).top(175).left(20).right(20)
    }
    
    // Add Subview Confirm Password Field
    private func prepareConfirmPasswordField() {
        self.view.addSubview(confirmPasswordField)
        self.view.layout(confirmPasswordField).top(260).left(20).right(20)
    }
    
    // Add Subview Sign Up Button
    private func prepareSignUpButton() {
        self.view.addSubview(signUpButton)
        self.view.layout(signUpButton).height(44).top(325).left(20).right(20)
    }
    
    // Sign Up User
    func performSignUp() {
        
        if isValid() {
            
            toggleEditing()
            
            let params = [
                Client.UserKeys.SignUp: emailField.text!.lowercased(),
                Client.UserKeys.Password: passwordField.text!
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
        
    }
    
    // Toggle Editing
    func toggleEditing() {
        emailField.isEnabled = !emailField.isEnabled
        passwordField.isEnabled = !passwordField.isEnabled
        confirmPasswordField.isEnabled = !confirmPasswordField.isEnabled
        signUpButton.isEnabled = !signUpButton.isEnabled
    }
    
    // Validate fields
    func isValid() -> Bool {
        if let emailID = emailField.text, !emailID.isValidEmail() {
            emailField.isErrorRevealed = true
            return false
        }
        if let password = passwordField.text, password.isEmpty, let confirmPassword = confirmPasswordField.text, confirmPassword.isEmpty || checkTextSufficientComplexity(text: password) {
            passwordField.isErrorRevealed = true
            return false
        }
        if let password = passwordField.text, let confirmPassword = confirmPasswordField.text, password != confirmPassword {
            confirmPasswordField.isErrorRevealed = true
            return false
        }
        return true
    }
    
    // Password validation
    func checkTextSufficientComplexity(text : String) -> Bool{
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        var texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalResult = texttest.evaluate(with: text)
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberResult = texttest1.evaluate(with: text)
        
        let lowercaseLetterRegEx  = ".*[a-z]+.*"
        texttest = NSPredicate(format:"SELF MATCHES %@", lowercaseLetterRegEx)
        let lowercaseResult = texttest.evaluate(with: text)
        
        return capitalResult && numberResult && lowercaseResult
        
    }

}

extension SignUpViewController: TextFieldDelegate {
    
    // Verify input data after editing over
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let emailID = emailField.text, !emailID.isValidEmail() && textField == emailField {
            emailField.isErrorRevealed = true
        } else {
            emailField.isErrorRevealed = false
        }
        
        if let password = passwordField.text, password.isEmpty && textField == passwordField && password.characters.count < 6 {
            passwordField.isErrorRevealed = true
        } else {
            passwordField.isErrorRevealed = false
        }
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
}
