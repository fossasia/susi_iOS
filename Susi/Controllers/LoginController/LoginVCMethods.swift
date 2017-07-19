//
//  LoginVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import BouncyLayout
import DLRadioButton
import RealmSwift

extension LoginViewController {

    func addTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }

    // Configures Email Text Field
    func prepareEmailField() {
        emailTextField.placeholderNormalColor = .white
        emailTextField.placeholderActiveColor = .white
        emailTextField.dividerNormalColor = .white
        emailTextField.dividerActiveColor = .red
        emailTextField.textColor = .white
        emailTextField.clearIconButton?.tintColor = .white
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }

    // Configures Password Text Field
    func preparePasswordField() {
        passwordTextField.placeholderNormalColor = .white
        passwordTextField.placeholderActiveColor = .white
        passwordTextField.dividerNormalColor = .white
        passwordTextField.dividerActiveColor = .red
        passwordTextField.textColor = .white
        passwordTextField.clearIconButton?.tintColor = .white
        passwordTextField.visibilityIconButton?.tintColor = .white
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }

    // Configures the radio buttons
    func prepareRadioButtons() {
        standardServerButton.addTarget(self, action: #selector(toggleRadioButtons), for: .touchUpInside)
        personalServerButton.addTarget(self, action: #selector(toggleRadioButtons), for: .touchUpInside)
    }

    func toggleRadioButtons(_ sender: Any) {
        if let button = sender as? DLRadioButton {
            if button == standardServerButton {
                personalServerButton.isSelected = false
                addressField.tag = 0
            } else if button == personalServerButton {
                standardServerButton.isSelected = false
                addressField.tag = 1
            }
            toggleAddressFieldDisplay()
        }
    }

    func toggleAddressFieldDisplay() {
        UIView.animate(withDuration: 0.5) {
            if self.addressField.tag == 1 {
                self.loginButtonTopConstraint.constant = 67
            } else {
                self.loginButtonTopConstraint.constant = 20
                self.addressField.endEditing(true)
            }
        }
    }

    func prepareAddressField() {
        addressField.placeholderNormalColor = .white
        addressField.placeholderActiveColor = .white
        addressField.dividerNormalColor = .white
        addressField.dividerActiveColor = .white
        addressField.textColor = .white
        addressField.clearIconButton?.tintColor = .white
    }

    // Configure Login Button
    func prepareLoginButton() {
        loginButton.addTarget(self, action: #selector(performLogin), for: .touchUpInside)
    }

    func prepareSkipButton() {
        skipButton.addTarget(self, action: #selector(enterAnonymousMode), for: .touchUpInside)
    }

    // Call Login API
    func performLogin() {

        if isValid() {
            toggleEditing()

            var params = [
                Client.UserKeys.Login: emailTextField.text!.lowercased(),
                Client.UserKeys.Password: passwordTextField.text!,
                Client.ChatKeys.ResponseType: Client.ChatKeys.AccessToken
            ] as [String : Any]

            if addressField.tag == 1 {
                UserDefaults.standard.set(Client.APIURLs.SusiAPI, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
            } else if let ipAddress = addressField.text {
                UserDefaults.standard.set(ipAddress, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
            }

            indicatorView.startAnimating()
            Client.sharedInstance.loginUser(params as [String : AnyObject]) { (user, success, message) in
                DispatchQueue.main.async {
                    self.toggleEditing()
                    if success {
                        self.completeLogin()
                        self.fetchUserSettings(user!.accessToken)
                    }
                    self.view.makeToast(message)
                    self.indicatorView.stopAnimating()
                }
            }
            params.removeAll()
        } else if let emailID = emailTextField.text, !emailID.isValidEmail() {
            self.view.makeToast("Invalid email address")
        } else if let password = passwordTextField.text, password.isEmpty {
            self.view.makeToast("Password length too short")
        }

    }

    func fetchUserSettings(_ accessToken: String) {
        let params = [
            Client.UserKeys.AccessToken: accessToken
        ]

        Client.sharedInstance.fetchUserSettings(params as [String : AnyObject]) { (success, message) in
            DispatchQueue.global().async {
                print("User settings fetch status: \(success) : \(message)")
            }
        }

    }

    // Keyboard Return Key Hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            _ = passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            dismissKeyboard()
            performLogin()
        }
        return false
    }

    func textFieldDidChange(textField: UITextField) {
        if textField == emailTextField, let emailID = emailTextField.text {
            if !emailID.isValidEmail() {
                emailTextField.dividerActiveColor = .red
            } else {
                emailTextField.dividerActiveColor = .green
            }
        } else if textField == passwordTextField, let password = passwordTextField.text {
            if password.isEmpty || password.characters.count < 5 {
                passwordTextField.dividerActiveColor = .red
            } else {
                passwordTextField.dividerActiveColor = .green
            }
        }
    }

    // force dismiss keyboard if open.
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

    // Toggle Editing
    func toggleEditing() {
        emailTextField.isEnabled = !emailTextField.isEnabled
        passwordTextField.isEnabled = !passwordTextField.isEnabled
        loginButton.isEnabled = !loginButton.isEnabled
    }

    // Clear field after login
    func clearFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    // Show sign up controller
    func presentSignUpController() {
        clearFields()

        let vc = SignUpViewController()
        self.present(vc, animated: true, completion: nil)
    }

    // Present Forgot Password VC
    func presentForgotPasswordController() {
        let vc = ForgotPasswordViewController()
        let nvc = AppNavigationController(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
    }

    // Validate fields
    func isValid() -> Bool {
        if let emailID = emailTextField.text, !emailID.isValidEmail() {
            return false
        }
        if let password = passwordTextField.text, password.isEmpty {
            return false
        }

        if addressField.tag == 0 {
            if let address = addressField.text, address.isEmpty {
                return false
            }
        }
        return true
    }

    // Present Main View Controller
    func completeLogin(_ firstLogin: Bool = true) {
        let layout = BouncyLayout()
        let vc = ChatViewController(collectionViewLayout: layout)
        let nvc = AppNavigationController(rootViewController: vc)
        self.present(nvc, animated: true, completion: {
            self.clearFields()
            if firstLogin {
                vc.loadMemoryFromNetwork = true
            }
        })
    }

    // Check existing session
    func checkSession() {
        if let user = UserDefaults.standard.value(forKey: ControllerConstants.UserDefaultsKeys.user) {
            if let user = user as? [String : AnyObject] {
                let user = User(dictionary: user)

                DispatchQueue.main.async {
                    if user.expiryTime > Date() {
                        self.completeLogin(false)
                        self.fetchUserSettings(user.accessToken)
                    } else {
                        self.resetDB()
                    }
                }
            }
        }
    }

    func enterAnonymousMode() {
        resetDB()
        UserDefaults.standard.set(Client.APIURLs.SusiAPI, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
        self.completeLogin()
    }

    func resetDB() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

}
