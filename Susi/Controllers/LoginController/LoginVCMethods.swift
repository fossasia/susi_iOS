//
//  LoginVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import BouncyLayout

extension LoginViewController {

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
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
    }

    // Add Subview Password Field
    private func preparePasswordField() {
        self.view.addSubview(passwordField)
        self.view.layout(passwordField)
            .center(offsetY: 0)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
    }

    // Add Subview Login Button
    private func prepareLoginButton() {
        self.view.addSubview(loginButton)
        self.view.layout(loginButton)
            .height(44)
            .center(offsetY: passwordField.height + 60)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
    }

    // Add Subview Forgot Button
    private func prepareForgotButton() {
        self.view.addSubview(forgotButton)
        self.view.layout(forgotButton)
            .height(44)
            .center(offsetY: passwordField.height + loginButton.height + 70)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
    }

    // Add Subview Sign Up Button
    private func prepareSignUpButton() {
        self.view.addSubview(signUpButton)
        self.view.layout(signUpButton)
            .height(44)
            .bottom(20)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
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

    // force dismiss keyboard if open.
    func dismissKeyboard() {
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

    // Show Forgot Password VC
    func showFPView() {
        let vc = ForgotPasswordViewController()
        let nvc = AppNavigationController(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
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
        let layout = BouncyLayout()
        let vc = MainViewController(collectionViewLayout: layout)
        let nvc = AppNavigationController(rootViewController: vc)
        self.present(nvc, animated: true, completion: {
            self.clearFields()
        })
    }

    // Check existing session
    func checkSession() {
        if let user = UserDefaults.standard.value(forKey: ControllerConstants.UserDefaultsKeys.user) {
            if let user = user as? [String : AnyObject] {
                _ = User(dictionary: user)

                DispatchQueue.main.async {
                    self.completeLogin()
                }
            }
        }
    }

}
