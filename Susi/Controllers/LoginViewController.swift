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
    lazy var loginButton: RaisedButton = {
        let button = RaisedButton()
        button.setTitle("LOGIN", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.defaultColor(), for: .normal)
        button.addTarget(self, action: #selector(performLogin), for: .touchUpInside)
        return button
    }()
    
    // Setup Forgot Button
    let forgotButton: FlatButton = {
        let button = FlatButton()
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // Setup Sign Up Button
    lazy var signUpButton: FlatButton = {
        let button = FlatButton()
        button.setTitle("Sign up for SUSI", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(showSignUpView), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        checkSession()
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
    }
    
    // Add Subview Logo
    private func prepareLogo() {
        self.view.addSubview(susiLogo)
        self.view.layout(susiLogo).top(50).centerHorizontally()
    }
    
    // Add Subview Email Field
    private func prepareEmailField() {
        self.view.addSubview(emailField)
        self.view.layout(emailField).center(offsetY: -passwordField.height - 140).left(20).right(20)
    }
    
    // Add Subview Password Field
    private func preparePasswordField() {
        self.view.addSubview(passwordField)
        self.view.layout(passwordField).center(offsetY: -60).left(20).right(20)
    }
    
    // Add Subview Login Button
    private func prepareLoginButton() {
        self.view.addSubview(loginButton)
        self.view.layout(loginButton).height(44).center(offsetY: passwordField.height).left(20).right(20)
    }
    
    // Add Subview Forgot Button
    private func prepareForgotButton() {
        self.view.addSubview(forgotButton)
        self.view.layout(forgotButton).height(44).center(offsetY: loginButton.frame.maxY + 60).left(20).right(20)
    }
    
    // Add Subview Sign Up Button
    private func prepareSignUpButton() {
        self.view.addSubview(signUpButton)
        self.view.layout(signUpButton).height(44).center(offsetY: forgotButton.height + 120).left(20).right(20)
    }
    
    // Login User
    func performLogin() {

        if isValid() {
            toggleEditing()
            
            let params = [
                Client.UserKeys.Login: emailField.text!.lowercased(),
                Client.UserKeys.Password: passwordField.text!,
                Client.ChatKeys.ResponseType: Client.ChatKeys.AccessToken
            ] as [String : Any]
            
            Client.sharedInstance.loginUser(params as [String : AnyObject]) { (_, success, message) in
                DispatchQueue.main.async {
                    self.toggleEditing()
                    if success {
                        self.completeLogin()
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
