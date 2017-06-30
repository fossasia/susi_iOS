//
//  SignUpVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import DLRadioButton

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
        prepareRadioButtons()
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
            .top(70)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
        self.view.layoutSubviews()
    }

    // Add Subview Password Field
    private func preparePasswordField() {
        self.view.addSubview(passwordField)
        self.view.layout(passwordField)
            .top(emailField.frame.maxY + emailField.frame.height)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
        self.view.layoutSubviews()
    }

    // Add Subview Confirm Password Field
    private func prepareConfirmPasswordField() {
        self.view.addSubview(confirmPasswordField)
        self.view.layout(confirmPasswordField)
            .top(passwordField.frame.maxY + passwordField.frame.height)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
        self.view.layoutSubviews()
    }

    func prepareRadioButtons() {
        self.view.addSubview(standardServerRB)
        self.view.layout(standardServerRB)
            .top(confirmPasswordField.frame.maxY + UIView.UIMarginSpec.mediumMargin)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
            .height(44)
        self.view.layoutSubviews()
        standardServerRB.addTarget(self, action: #selector(toggleRadioButtons), for: .touchUpInside)

        self.view.addSubview(customServerRB)
        self.view.layout(customServerRB)
            .top(standardServerRB.frame.maxY)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
        self.view.layoutSubviews()
        customServerRB.addTarget(self, action: #selector(toggleRadioButtons), for: .touchUpInside)

        self.view.addSubview(self.customServerAddressField)
        self.view.layout(self.customServerAddressField)
            .top(self.customServerRB.frame.maxY + 10)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
        self.view.layoutSubviews()
    }

    func toggleRadioButtons(_ sender: Any) {
        let button = sender as? DLRadioButton
        if button == standardServerRB {
            customServerRB.isSelected = false
            customServerAddressField.tag = 0
        } else if button == customServerRB {
            standardServerRB.isSelected = false
            customServerAddressField.tag = 1
        }
        addAddressField()
    }

    func addAddressField() {
        UIView.animate(withDuration: 0.5) {
            if self.customServerAddressField.tag == 0 {
                self.signUpButton.frame.origin.y = self.customServerAddressField.frame.minY
            } else {
                self.signUpButton.frame.origin.y = self.customServerAddressField.frame.maxY + UIView.UIMarginSpec.mediumMargin
            }
            self.view.layoutIfNeeded()
        }
    }

    // Add Subview Sign Up Button
    private func prepareSignUpButton() {
        self.view.addSubview(signUpButton)
        self.view.layout(signUpButton)
            .height(44)
            .top(customServerAddressField.frame.minY)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
    }

    // Sign Up User
    func performSignUp() {

        if isValid() {

            toggleEditing()

            var params = [
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
            params.removeAll()
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
