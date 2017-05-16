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
        textField.detail = "Error, incorrect email"
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
        prepareEmailField()
        preparePasswordField()
        prepareLoginButton()
        prepareForgotButton()
        prepareSignUpButton()
        prepareActivityIndicator()
    }
    
    // Add Subview Logo
    private func prepareLogo() {
        self.view.addSubview(susiLogo)
        self.view.layout(susiLogo).top(50).centerHorizontally()
    }
    
    // Add Subview Email Field
    private func prepareEmailField() {
        self.view.addSubview(emailField)
        self.view.layout(emailField)
            .center(offsetY: -passwordField.height - 80)
            .left(CGFloat(UIView.UIMarginSpec.MARGIN_MEDIUM))
            .right(CGFloat(UIView.UIMarginSpec.MARGIN_MEDIUM))
    }
    
    // Add Subview Password Field
    private func preparePasswordField() {
        self.view.addSubview(passwordField)
        self.view.layout(passwordField)
            .center(offsetY: 0)
            .left(CGFloat(UIView.UIMarginSpec.MARGIN_MEDIUM))
            .right(CGFloat(UIView.UIMarginSpec.MARGIN_MEDIUM))
    }
    
    // Add Subview Login Button
    private func prepareLoginButton() {
        self.view.addSubview(loginButton)
        self.view.layout(loginButton)
            .height(44)
            .center(offsetY: passwordField.height + 60)
            .left(CGFloat(UIView.UIMarginSpec.MARGIN_MEDIUM))
            .right(CGFloat(UIView.UIMarginSpec.MARGIN_MEDIUM))
    }
    
    // Add Subview Forgot Button
    private func prepareForgotButton() {
        self.view.addSubview(forgotButton)
        self.view.layout(forgotButton)
            .height(44)
            .center(offsetY: passwordField.height + loginButton.height + 90)
            .left(CGFloat(UIView.UIMarginSpec.MARGIN_MEDIUM))
            .right(CGFloat(UIView.UIMarginSpec.MARGIN_MEDIUM))
    }
    
    // Add Subview Activity Indicator
    private func prepareActivityIndicator() {
        self.view.addSubview(activityIndicator)
        loginButton.layout(activityIndicator)
            .centerHorizontally()
            .top(activityIndicator, top: loginButton.height + 10)
    }
    
    // Add Subview Sign Up Button
    private func prepareSignUpButton() {
        self.view.addSubview(signUpButton)
        self.view.layout(signUpButton)
            .height(44)
            .bottom(20)
            .left(CGFloat(UIView.UIMarginSpec.MARGIN_MEDIUM))
            .right(CGFloat(UIView.UIMarginSpec.MARGIN_MEDIUM))
    }
    
    // Login User
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
    
    // Login User
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
