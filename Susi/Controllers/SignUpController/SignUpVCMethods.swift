//
//  SignUpVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import M13Checkbox
import SwiftValidators

extension SignUpViewController {

    func addTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func prepareFields() {
        emailTextField.placeholderNormalColor = .white
        emailTextField.placeholderActiveColor = .white
        emailTextField.text = UserDefaults.standard.value(forKey: ControllerConstants.UserDefaultsKeys.typedEmailAdress) as? String ?? ""
        emailTextField.dividerNormalColor = .white
        emailTextField.dividerActiveColor = .white
        emailTextField.textColor = .white
        emailTextField.clearIconButton?.tintColor = .white
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)

        passwordTextField.placeholderNormalColor = .white
        passwordTextField.placeholderActiveColor = .white
        passwordTextField.dividerNormalColor = .white
        passwordTextField.dividerActiveColor = .white
        passwordTextField.textColor = .white
        passwordTextField.visibilityIconButton?.tintColor = .white
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)

        confirmPasswordTextField.placeholderNormalColor = .white
        confirmPasswordTextField.placeholderActiveColor = .white
        confirmPasswordTextField.dividerNormalColor = .white
        confirmPasswordTextField.dividerActiveColor = .white
        confirmPasswordTextField.textColor = .white
        confirmPasswordTextField.visibilityIconButton?.tintColor = .white
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)

        addressTextField.placeholderNormalColor = .white
        addressTextField.placeholderActiveColor = .white
        addressTextField.dividerNormalColor = .white
        addressTextField.dividerActiveColor = .white
        addressTextField.textColor = .white
    }

    func prepareSignUpButton() {
        signUpButton.addTarget(self, action: #selector(performSignUp), for: .touchUpInside)
    }
    
    //declare delegate
    func addDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }

    // Dismiss View Controller
    @IBAction func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func toggleRadioButtons(_ sender: M13Checkbox) {
        if sender.checkState == .checked {
            addressTextField.tag = 1
            addressTextField.isUserInteractionEnabled = true
        } else {
            addressTextField.tag = 0
            addressTextField.isUserInteractionEnabled = false
            addressTextField.text = ""
        }
    }

    // Sign Up User
    @objc func performSignUp() {

        if isValid() {

            toggleEditing()
            activityIndicator.startAnimating()

            let params = [
                Client.UserKeys.SignUp: emailTextField.text!.lowercased(),
                Client.UserKeys.Password: passwordTextField.text!
            ]

            if personalServerButton.checkState == .unchecked {
                UserDefaults.standard.set(Client.APIURLs.SusiAPI, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
            } else {
                if let ipAddress = addressTextField.text, !ipAddress.isEmpty && Validator.isIP().apply(ipAddress) {
                    UserDefaults.standard.set(ipAddress, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
                } else {
                    view.makeToast(ControllerConstants.invalidIP.localized())
                    return
                }
            }

            Client.sharedInstance.registerUser(params as [String: AnyObject]) { (success, message) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.toggleEditing()
                    if success {
                        self.view.makeToast(ControllerConstants.SignUp.successSignup)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            self.dismissView()
                        })
                    }
                    self.view.makeToast(message)
                }
            }
        } else if let emailID = emailTextField.text, !emailID.isValidEmail() {
            view.makeToast(ControllerConstants.invalidEmailAddress.localized())
        } else if let password = passwordTextField.text, password.isEmpty {
            view.makeToast(ControllerConstants.passwordLengthTooShort.localized())
        } else if let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text, password != confirmPassword {
            view.makeToast(ControllerConstants.passwordDoNotMatch.localized())
        }

    }

    // function called on return button click of keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            _ = passwordTextField.becomeFirstResponder()
        case passwordTextField:
            _ = confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            dismissKeyboard()
            performSignUp()
        default:
            textField.resignFirstResponder()
        }
        return true
    }

    @objc func textFieldDidChange(textField: UITextField) {
        if textField == emailTextField, let emailID = emailTextField.text {
            if !emailID.isValidEmail() {
                emailTextField.dividerActiveColor = .red
            } else {
                emailTextField.dividerActiveColor = .green
            }
        } else if textField == passwordTextField, let password = passwordTextField.text {
            if password.isEmpty || password.count < 6 || password.count > 64 {
                passwordTextField.dividerActiveColor = .red
            } else {
                passwordTextField.dividerActiveColor = .green
            }
        } else if textField == confirmPasswordTextField, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text {
            if password != confirmPassword {
                confirmPasswordTextField.dividerActiveColor = .red
            } else {
                confirmPasswordTextField.dividerActiveColor = .green
            }
        }
    }

    // dismiss keyboard if open.
    @objc func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    // Toggle Editing
    func toggleEditing() {
        emailTextField.isEnabled = !emailTextField.isEnabled
        passwordTextField.isEnabled = !passwordTextField.isEnabled
        confirmPasswordTextField.isEnabled = !confirmPasswordTextField.isEnabled
        signUpButton.isEnabled = !signUpButton.isEnabled
    }

    // Validate fields
    func isValid() -> Bool {
        if let emailID = emailTextField.text, !emailID.isValidEmail() {
            return false
        }
        if let password = passwordTextField.text, password.isEmpty, let confirmPassword = confirmPasswordTextField.text, confirmPassword.isEmpty || password.isTextSufficientComplexity {
            return false
        }
        if let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text, password != confirmPassword {
            return false
        }
        if personalServerButton.checkState == .checked {
            if let address = addressTextField.text, address.isEmpty {
                return false
            }
        }
        return true
    }

    // Check if email is already registered or not
    func checkIfEmailAlreadyExists() {
        let emailCheckParam = [
            Client.UserKeys.CheckEmail: emailTextField.text!.lowercased() as AnyObject
        ]
        Client.sharedInstance.checkRegistration(emailCheckParam) { (exists, success) in
            DispatchQueue.main.async {
                if success, exists! {
                    self.view.makeToast(ControllerConstants.emailAlreadyExists)
                }
            }
        }
    }

}

extension SignUpViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.accessibilityIdentifier == "email" {
            checkIfEmailAlreadyExists()
        }
    }

}
