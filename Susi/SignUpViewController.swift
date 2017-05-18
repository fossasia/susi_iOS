//
//  SignUpViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import MaterialComponents
import SnapKit

class SignUpViewController: UIViewController {

    // Setup Dismiss Button
    let dismissButton: MDCButton = {
        let ib = MDCButton()
        ib.setImage(Icon.cm.arrowBack, for: .normal)
        ib.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        ib.backgroundColor = .clear
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
        textField.detailLabel.text = "Should be 6 characters long with one uppercase, lowercase and a digit"
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
    lazy var signUpButton: MDCRaisedButton = {
        let button = MDCRaisedButton()
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
        prepareConfirmPasswordField()
        preparePasswordField()
        prepareEmailField()
        prepareSignUpButton()
    }
    
    // Adds Dismiss Button
    func prepareDismissButton() {
        self.view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.top.equalTo(UIView.UIMarginSpec.MARGIN_MEDIUM)
        }
    }
    
    // Dismiss View Controller
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Adds Email Field
    private func prepareEmailField() {
        self.view.addSubview(emailField)
        emailField.snp.makeConstraints { (make) in
            make.top.equalTo(passwordField).offset(-UIView.UIMarginSpec.MARGIN_MAX)
            make.left.equalTo(UIView.UIMarginSpec.MARGIN_MEDIUM)
            make.right.equalTo(-UIView.UIMarginSpec.MARGIN_MEDIUM)
        }
    }
    
    // Adds Password Field
    private func preparePasswordField() {
        self.view.addSubview(passwordField)
        passwordField.snp.makeConstraints { (make) in
            make.top.equalTo(confirmPasswordField).offset(-UIView.UIMarginSpec.MARGIN_MAX)
            make.left.equalTo(UIView.UIMarginSpec.MARGIN_MEDIUM)
            make.right.equalTo(-UIView.UIMarginSpec.MARGIN_MEDIUM)
        }
    }
    
    // Add Subview Confirm Password Field
    private func prepareConfirmPasswordField() {
        self.view.addSubview(confirmPasswordField)
        confirmPasswordField.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.left.equalTo(UIView.UIMarginSpec.MARGIN_MEDIUM)
            make.right.equalTo(-UIView.UIMarginSpec.MARGIN_MEDIUM)
        }
    }
    
    // Adds Sign Up Button
    private func prepareSignUpButton() {
        self.view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.top.equalTo(confirmPasswordField).offset(UIView.UIMarginSpec.MARGIN_MAX)
            make.left.equalTo(UIView.UIMarginSpec.MARGIN_MEDIUM)
            make.right.equalTo(-UIView.UIMarginSpec.MARGIN_MEDIUM)
            make.height.equalTo(44)
        }
    }
    
    // Hit SignUp button
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
    
    // function called on return button click of keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }
    
    // dismiss keyboard if open.
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
