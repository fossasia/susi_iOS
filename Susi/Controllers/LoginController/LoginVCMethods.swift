//
//  LoginVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import BouncyLayout
import M13Checkbox
import RealmSwift
import SwiftValidators

extension LoginViewController {

    func addTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
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

    // Configure Login Button
    func prepareLoginButton() {
        loginButton.addTarget(self, action: #selector(performLogin), for: .touchUpInside)
    }

    func prepareSkipButton() {
        skipButton.addTarget(self, action: #selector(enterAnonymousMode), for: .touchUpInside)
    }

    func prepareAddressField() {
        addressTextField.placeholderNormalColor = .white
        addressTextField.placeholderActiveColor = .white
        addressTextField.dividerNormalColor = .white
        addressTextField.dividerActiveColor = .white
        addressTextField.textColor = .white
    }

    // Call Login API
    func performLogin() {
        if isValid() {
            toggleEditing()

            let params = [
                Client.UserKeys.Login: emailTextField.text!.lowercased(),
                Client.UserKeys.Password: passwordTextField.text!,
                Client.ChatKeys.ResponseType: Client.ChatKeys.AccessToken
            ] as [String : Any]

            if personalServerButton.checkState == .unchecked {
                UserDefaults.standard.set(Client.APIURLs.SusiAPI, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
            } else {
                if let ipAddress = addressTextField.text, !ipAddress.isEmpty && Validator.isIP().apply(ipAddress) {
                    UserDefaults.standard.set(ipAddress, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
                } else {
                    view.makeToast("Invalid IP Address")
                    return
                }
            }

            indicatorView.startAnimating()
            Client.sharedInstance.loginUser(params as [String : AnyObject]) { (user, results, success, message) in
                DispatchQueue.main.async {
                    self.toggleEditing()
                    if success {
                        if var userData = results {
                            userData[Client.UserKeys.EmailOfAccount] = (message.components(separatedBy: " ").last ?? "") as AnyObject
                            UserDefaults.standard.set(userData, forKey: ControllerConstants.UserDefaultsKeys.user)
                            let currentUser = User(dictionary: userData)
                            print(currentUser.emailID)
                            self.saveUserGlobally(user: currentUser)
                            self.completeLogin()
                            self.fetchUserSettings(currentUser.accessToken)
                        }
                    }
                    self.view.makeToast(message)
                    self.indicatorView.stopAnimating()
                }
            }
        } else if let emailID = emailTextField.text, !emailID.isValidEmail() {
            view.makeToast("Invalid email address")
        } else if let password = passwordTextField.text, password.isEmpty {
            view.makeToast("Password length too short")
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
        view.endEditing(true)
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
        present(vc, animated: true, completion: nil)
    }

    // Validate fields
    func isValid() -> Bool {
        if let emailID = emailTextField.text, !emailID.isValidEmail() {
            return false
        }
        if let password = passwordTextField.text, password.isEmpty {
            return false
        }
        if personalServerButton.checkState == .checked {
            if let address = addressTextField.text, address.isEmpty {
                return false
            }
        }
        return true
    }

    // Present Main View Controller
    func completeLogin(_ firstLogin: Bool = true) {
        let layout = BouncyLayout()
        let vc = ChatViewController(collectionViewLayout: layout)
        present(vc, animated: true, completion: {
            self.clearFields()
            if firstLogin {
                vc.loadMemoryFromNetwork = true
            }
        })
    }

    // Check existing session
    func checkSession() {
        if let userDefaultValue = UserDefaults.standard.value(forKey: ControllerConstants.UserDefaultsKeys.user) {
            if let userData = userDefaultValue as? [String : AnyObject] {
                let user = User(dictionary: userData)
                saveUserGlobally(user: user)

                DispatchQueue.main.async {
                    if Date() > user.expiryTime {
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
        resetSettings()
        UserDefaults.standard.set(Client.APIURLs.SusiAPI, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
        completeLogin()
    }

    func resetDB() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

    func setupTheme() {
        let image = UIImage(named: "susi")
        susiLogo.image = image
        susiLogo.tintColor = .white
        UIApplication.shared.statusBarStyle = .lightContent
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "#4184F3")
    }

    func saveUserGlobally(user: User) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.currentUser = user
        }
    }

    func resetSettings() {
        UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.enterToSend)
        UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.micInput)
        UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.hotwordEnabled)
        UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.speechOutput)
        UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.speechOutputAlwaysOn)
        UserDefaults.standard.set(0.5, forKey: ControllerConstants.UserDefaultsKeys.speechRate)
        UserDefaults.standard.set(0.5, forKey: ControllerConstants.UserDefaultsKeys.speechRate)
        UserDefaults.standard.set("en", forKey: ControllerConstants.UserDefaultsKeys.prefLanguage)
    }

}
