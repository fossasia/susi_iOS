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

    // Setup View
    func setupView() {
        self.view.backgroundColor = UIColor.defaultColor()

        prepareScrollView()
        prepareLogo()
        prepareEmailField()
        preparePasswordField()
        prepareRadioButtons()
        prepareLoginButton()
        prepareForgotButton()
        prepareSkipButton()
        prepareSignUpButton()
    }

    // Add Subview Scroll View
    func prepareScrollView() {
        self.view.addSubview(scrollView)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 1.2)
    }

    // Add Subview Logo
    private func prepareLogo() {
        self.scrollView.addSubview(susiLogo)
        self.scrollView.layout(susiLogo)
            .top(50)
            .centerHorizontally()
    }

    // Add Subview Email Field
    private func prepareEmailField() {
        self.scrollView.addSubview(emailField)
        self.scrollView.layout(emailField)
            .top(susiLogo.frame.maxY + susiLogo.frame.height + 30)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
            .width(view.frame.width - 40)
        self.scrollView.layoutIfNeeded()
    }

    // Add Subview Password Field
    private func preparePasswordField() {
        self.scrollView.addSubview(passwordField)
        self.scrollView.layout(passwordField)
            .top(emailField.frame.maxY + emailField.frame.height + 20)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
        self.scrollView.layoutSubviews()
    }

    func prepareRadioButtons() {
        self.scrollView.addSubview(standardServerRB)
        self.scrollView.layout(standardServerRB)
            .top(passwordField.frame.maxY + 20)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
            .height(44)
        self.scrollView.layoutSubviews()
        standardServerRB.addTarget(self, action: #selector(toggleRadioButtons), for: .touchUpInside)

        self.scrollView.addSubview(customServerRB)
        self.scrollView.layout(customServerRB)
            .top(standardServerRB.frame.maxY)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
        self.scrollView.layoutSubviews()
        customServerRB.addTarget(self, action: #selector(toggleRadioButtons), for: .touchUpInside)

        self.scrollView.addSubview(self.customServerAddressField)
        self.scrollView.layout(self.customServerAddressField)
            .top(self.customServerRB.frame.maxY + 10)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
        self.scrollView.layoutSubviews()
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
                self.loginButton.frame.origin.y = self.customServerRB.frame.maxY + UIView.UIMarginSpec.smallMargin
                self.forgotButton.frame.origin.y = self.loginButton.frame.maxY
                self.signUpButton.frame.origin.y = self.forgotButton.frame.maxY + self.forgotButton.frame.height
            } else {
                self.loginButton.frame.origin.y = self.customServerRB.frame.maxY + UIView.UIMarginSpec.largeMatgin + 20
                self.forgotButton.frame.origin.y = self.loginButton.frame.maxY + UIView.UIMarginSpec.smallMargin
                self.signUpButton.frame.origin.y  = self.forgotButton.frame.maxY + self.forgotButton.frame.height
            }
            self.scrollView.layoutIfNeeded()
        }
    }

    // Add Subview Login Button
    private func prepareLoginButton() {
        self.scrollView.addSubview(loginButton)
        self.scrollView.layout(loginButton)
            .top(customServerRB.frame.maxY + 20)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
            .height(44)
        self.scrollView.layoutSubviews()
    }

    // Add Subview Forgot Button
    private func prepareForgotButton() {
        self.scrollView.addSubview(forgotButton)
        self.scrollView.layout(forgotButton)
            .top(loginButton.frame.maxY + UIView.UIMarginSpec.smallMargin)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
            .height(44)
        self.scrollView.layoutSubviews()
    }

    private func prepareSkipButton() {
        self.scrollView.addSubview(skip)
        self.scrollView.layout(skip)
            .top(forgotButton.frame.maxY)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
            .height(22)
        self.scrollView.layoutSubviews()
    }

    // Add Subview Sign Up Button
    private func prepareSignUpButton() {
        self.scrollView.addSubview(signUpButton)
        self.scrollView.layout(signUpButton)
            .top(forgotButton.frame.maxY + forgotButton.frame.height)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
            .height(44)
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

            if customServerAddressField.tag == 0 {
                UserDefaults.standard.set(Client.APIURLs.SusiAPI, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
            } else {
                UserDefaults.standard.set(customServerAddressField.text!, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
            }

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
        if customServerAddressField.tag == 1 {
            if let address = customServerAddressField.text, address.isEmpty {
                return false
            }
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

    func anonymousMode() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        UserDefaults.standard.set(Client.APIURLs.SusiAPI, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
        self.completeLogin()
    }

}
