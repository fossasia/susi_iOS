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

    // Define UI margin constants
    struct UIMarginSpec {
        static let smallMargin = 10
        static let mediumMargin = 20
    }

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
            .left(CGFloat(UIMarginSpec.mediumMargin))
            .right(CGFloat(UIMarginSpec.mediumMargin))
    }

    // Add Subview Password Field
    private func preparePasswordField() {
        self.view.addSubview(passwordField)
        self.view.layout(passwordField)
            .center(offsetY: 0)
            .left(CGFloat(UIMarginSpec.mediumMargin))
            .right(CGFloat(UIMarginSpec.mediumMargin))
    }

    // Add Subview Login Button
    private func prepareLoginButton() {
        self.view.addSubview(loginButton)
        self.view.layout(loginButton)
            .height(44)
            .center(offsetY: passwordField.height + 60)
            .left(CGFloat(UIMarginSpec.mediumMargin))
            .right(CGFloat(UIMarginSpec.mediumMargin))
    }

    // Add Subview Forgot Button
    private func prepareForgotButton() {
        self.view.addSubview(forgotButton)
        self.view.layout(forgotButton)
            .height(44)
            .center(offsetY: passwordField.height + loginButton.height + 70)
            .left(CGFloat(UIMarginSpec.mediumMargin))
            .right(CGFloat(UIMarginSpec.mediumMargin))
    }

    // Add Subview Sign Up Button
    private func prepareSignUpButton() {
        self.view.addSubview(signUpButton)
        self.view.layout(signUpButton)
            .height(44)
            .bottom(20)
            .left(CGFloat(UIMarginSpec.mediumMargin))
            .right(CGFloat(UIMarginSpec.mediumMargin))
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

    // function called on return button click of keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }

    // dismiss keyboard if open.
    func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
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
            _ = User(dictionary: user as! [String : AnyObject])

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
