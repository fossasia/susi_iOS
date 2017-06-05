//
//  SignUpVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

extension SignUpViewController {

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
            .topLeft(top: UIView.UIMarginSpec.mediumMargin, left: 8)
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
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
    }

    // Add Subview Password Field
    private func preparePasswordField() {
        self.view.addSubview(passwordField)
        self.view.layout(passwordField)
            .center(offsetY: -confirmPasswordField.height - 100)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
    }

    // Add Subview Confirm Password Field
    private func prepareConfirmPasswordField() {
        self.view.addSubview(confirmPasswordField)
        self.view.layout(confirmPasswordField)
            .center(offsetY: 0)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
    }

    // Add Subview Sign Up Button
    private func prepareSignUpButton() {
        self.view.addSubview(signUpButton)
        self.view.layout(signUpButton)
            .height(44)
            .center(offsetY: confirmPasswordField.height + 70)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
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
    func checkTextSufficientComplexity(text: String) -> Bool {

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
