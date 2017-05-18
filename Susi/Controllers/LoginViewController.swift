//
//  LoginViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import Toast_Swift
import SwiftValidators
import MaterialComponents.MaterialButtons
import SnapKit

class LoginViewController: UIViewController {
    
    // Setup Susi Logo
    let susiLogo: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "susi")
        return iv
    }()
    
    // Setup Email Text Field
    lazy var emailField: AuthTextField = {
        let textField = AuthTextField()
        textField.keyboardType = .emailAddress
        textField.placeholder = "Email Address"
        textField.detail = "Error, Email not valid"
        textField.delegate = self
        return textField
    }()
    
    // Setup Password Field
    lazy var passwordField: AuthTextField = {
        let textField = AuthTextField()
        textField.placeholder = "Password"
        textField.detail = "Error, Should be at least 8 characters"
        textField.isVisibilityIconButtonEnabled = true
        textField.visibilityIconButton?.tintColor = Color.white.withAlphaComponent(textField.isSecureTextEntry ? 0.38 : 0.54)
        textField.delegate = self
        return textField
    }()
    
    // Setup Login Button
    lazy var loginButton: MDCRaisedButton = {
        let button = MDCRaisedButton()
        button.setTitle("LOGIN", for: .normal)
        button.setBackgroundColor(.white, for: .normal)
        button.setTitleColor(UIColor.defaultColor(), for: .normal)
        button.addTarget(self, action: #selector(performLogin), for: .touchUpInside)
        return button
    }()
    
    // Setup Forgot Button
    let forgotButton: MDCFlatButton = {
        let button = MDCFlatButton()
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // Setup Sign Up Button
    lazy var signUpButton: MDCFlatButton = {
        let button = MDCFlatButton()
        button.setTitle("Sign up for SUSI", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(showSignUpView), for: .touchUpInside)
        return button
    }()
    
    // Activity Indicator
    let activityIndicator: MDCActivityIndicator = {
        let indicator = MDCActivityIndicator(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        indicator.strokeWidth = 2.0
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        checkSession()
        addTapGesture()
    }
    
    func addTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    // Setup View
    func setupView() {
        self.view.backgroundColor = UIColor.defaultColor()
        
        prepareLogo()
        preparePasswordField()
        prepareEmailField()
        prepareLoginButton()
        prepareActivityIndicator()
        prepareForgotButton()
        prepareSignUpButton()
    }
    
    // Adds Susi Logo
    private func prepareLogo() {
        self.view.addSubview(susiLogo)
        susiLogo.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(50)
            make.centerX.equalTo(self.view)
        }
    }
    
    // Adds Email Field
    private func prepareEmailField() {
        self.view.addSubview(emailField)
        emailField.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view).offset(-passwordField.height - UIView.UIMarginSpec.MARGIN_MAX)
            make.left.equalTo(self.view).offset(UIView.UIMarginSpec.MARGIN_MEDIUM)
            make.right.equalTo(self.view).offset(-UIView.UIMarginSpec.MARGIN_MEDIUM)
        }
    }
    
    // Adds Password Field
    private func preparePasswordField() {
        self.view.addSubview(passwordField)
        passwordField.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view).offset(UIView.UIMarginSpec.MARGIN_SMALL)
            make.left.equalTo(self.view).offset(UIView.UIMarginSpec.MARGIN_MEDIUM)
            make.right.equalTo(self.view).offset(-UIView.UIMarginSpec.MARGIN_MEDIUM)
        }
    }
    
    // Adds Login Button
    private func prepareLoginButton() {
        self.view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordField).offset(passwordField.height + UIView.UIMarginSpec.MARGIN_MAX)
            make.left.equalTo(self.view).offset(UIView.UIMarginSpec.MARGIN_MEDIUM)
            make.right.equalTo(self.view).offset(-UIView.UIMarginSpec.MARGIN_MEDIUM)
            make.height.equalTo(44.0)
        }
    }
    
    // Adds Activity Indicator
    private func prepareActivityIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton).offset(loginButton.height + UIView.UIMarginSpec.MARGIN_MAX - UIView.UIMarginSpec.MARGIN_MEDIUM)
            make.centerX.equalTo(self.view)
        }
    }
    
    // Adds Forgot Button
    private func prepareForgotButton() {
        self.view.addSubview(forgotButton)
        forgotButton.snp.makeConstraints { (make) in
            make.top.equalTo(activityIndicator).offset(30)
            make.centerX.equalTo(self.view)
            make.left.equalTo(self.view).offset(UIView.UIMarginSpec.MARGIN_MEDIUM)
            make.right.equalTo(self.view).offset(-UIView.UIMarginSpec.MARGIN_MEDIUM)
        }
    }
    
    // Adds Sign Up Button
    private func prepareSignUpButton() {
        self.view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-UIView.UIMarginSpec.MARGIN_MEDIUM)
            make.left.equalTo(self.view).offset(UIView.UIMarginSpec.MARGIN_MEDIUM)
            make.right.equalTo(self.view).offset(-UIView.UIMarginSpec.MARGIN_MEDIUM)
        }
    }
    
    // Hit login button
    func performLogin() {

        if isValid() {
            toggleEditing()
            self.activityIndicator.startAnimating()
            let params = [
                Client.UserKeys.Login: emailField.text!.lowercased(),
                Client.UserKeys.Password: passwordField.text!,
                Client.ChatKeys.ResponseType: Client.ChatKeys.AccessToken
            ] as [String : Any]
            
            Client.sharedInstance.loginUser(params as [String : AnyObject]) { (_, success, message) in
                DispatchQueue.main.async {
                    self.toggleEditing()
                    self.activityIndicator.stopAnimating()
                    if success {
                        self.completeLogin()
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
        loginButton.isEnabled = !loginButton.isEnabled
    }
    
    // Clear field after login
    func clearFields() {
        emailField.text = ""
        passwordField.text = ""
    }
    
    // Show sign up controller
    func showSignUpView() {
        clearFields()
        
        let vc = SignUpViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    // Validate fields
    func isValid() -> Bool {
        if let emailID = emailField.text, !emailID.isValidEmail() {
            emailField.isErrorRevealed = true
            return false
        }
        if let password = passwordField.text, password.isEmpty {
            passwordField.isErrorRevealed = true
            return false
        }
        return true
    }
    
    // Complete Login and Push
    func completeLogin() {
        let vc = MainViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let nvc = AppNavigationController(rootViewController: vc)
        self.present(nvc, animated: true, completion: {
            self.clearFields()
        })
    }
    
    // Check existing session
    func checkSession() {
        if let user = UserDefaults.standard.value(forKey: "user") {
            let _ = User(dictionary: user as! [String : AnyObject])
            
            DispatchQueue.main.async {
                self.completeLogin()
            }
        }
    }

}

extension LoginViewController: TextFieldDelegate {
    
    // Verify input data after editing over
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let emailID = emailField.text, !emailID.isValidEmail() && textField == emailField {
            emailField.isErrorRevealed = true
        } else {
            emailField.isErrorRevealed = false
        }
        
        if let password = passwordField.text, password.isEmpty && textField == passwordField {
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
