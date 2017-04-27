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
    
    // Define UI margin constants
    struct UIMarginSpec {
        static let MARGIN_SMALL = 10
        static let MARGIN_MEDIUM = 20;
    }

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
        textField.delegate = self
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
        addTapGesture()
    }
    
    func addTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
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
        self.view.layout(dismissButton)
            .topLeft(top: CGFloat(UIMarginSpec.MARGIN_MEDIUM), left: 8)
    }
    
    // Dismiss View Controller
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Add Subview Email Field
    private func prepareEmailField() {
        self.view.addSubview(emailField)
        self.view.layout(emailField)
            .center(offsetY: -confirmPasswordField.height - passwordField.height - 180)
            .left(CGFloat(UIMarginSpec.MARGIN_MEDIUM))
            .right(CGFloat(UIMarginSpec.MARGIN_MEDIUM))
    }
    
    // Add Subview Password Field
    private func preparePasswordField() {
        self.view.addSubview(passwordField)
        self.view.layout(passwordField)
            .center(offsetY: -confirmPasswordField.height - 100)
            .left(CGFloat(UIMarginSpec.MARGIN_MEDIUM))
            .right(CGFloat(UIMarginSpec.MARGIN_MEDIUM))
    }
    
    // Add Subview Confirm Password Field
    private func prepareConfirmPasswordField() {
        self.view.addSubview(confirmPasswordField)
        self.view.layout(confirmPasswordField)
            .center(offsetY: 0)
            .left(CGFloat(UIMarginSpec.MARGIN_MEDIUM))
            .right(CGFloat(UIMarginSpec.MARGIN_MEDIUM))
    }
    
    // Add Subview Sign Up Button
    private func prepareSignUpButton() {
        self.view.addSubview(signUpButton)
        self.view.layout(signUpButton)
            .height(44)
            .center(offsetY: confirmPasswordField.height + 70)
            .left(CGFloat(UIMarginSpec.MARGIN_MEDIUM))
            .right(CGFloat(UIMarginSpec.MARGIN_MEDIUM))
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
    
    //function called on return button click of keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }
    
    //dismiss keyboard if open.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
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
