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

extension LoginViewController: UITextFieldDelegate {

    func addTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setupView() {
        skipButton.titleColor = .white
        forgotPassword.titleColor = .white
        signUpButton.titleColor = .white
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

    func checkReachability() {
        reachability.whenReachable = { reachability in
            self.setUIBasedOnReachability(value: true)
        }
        reachability.whenUnreachable = { reachability in
            self.setUIBasedOnReachability(value: false)
        }
    }

    func setUIBasedOnReachability(value: Bool) {
        DispatchQueue.main.async {
            self.loginButton.isEnabled = value
            self.forgotPassword.isEnabled = value
            self.skipButton.isEnabled = value
            self.forgotPassword.isEnabled = value
            self.skipButton.isEnabled = value
            self.signUpButton.isEnabled = value
            if value {
                self.alert.dismiss(animated: true, completion: nil)
            } else {
                self.present(self.alert, animated: true, completion: nil)
            }
        }
    }
    
    //Declare delegates
    func addDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
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

    func addForgotPasswordAction() {
        forgotPassword.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
    }

    // Call Reset Password API
    @objc func resetPassword() {
        if let emailID = emailTextField.text, !emailID.isEmpty && emailID.isValidEmail() {

            let params = [
                Client.UserKeys.ForgotEmail: emailTextField.text?.lowercased()
            ]

            if personalServerButton.checkState == .unchecked {
                UserDefaults.standard.set(Client.APIURLs.SusiAPI, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
            } else {
                if let ipAddress = addressTextField.text, !ipAddress.isEmpty && Validator.isIP().apply(ipAddress) || ipAddress.isValidURL() {
                    UserDefaults.standard.set(ipAddress, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
                } else {
                    view.makeToast(ControllerConstants.invalidIP.localized())
                    return
                }
            }

            self.indicatorView.startAnimating()

            Client.sharedInstance.recoverPassword(params as [String: AnyObject]) { (_, _) in
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()

                    self.presentMailConfirmationScreen()

                    self.emailTextField.text = ""
                    self.emailTextField.endEditing(true)
                }
            }
        } else {
            self.view.makeToast(ControllerConstants.invalidEmailAddress.localized())
        }
    }

    func presentMailConfirmationScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mailConfirmationVC = storyboard.instantiateViewController(withIdentifier: "ForgotPassowrdVC")
        present(mailConfirmationVC, animated: true, completion: nil)
    }

    // Call Login API
    @objc func performLogin() {
        if isValid() {
            toggleEditing()

            let params = [
                Client.UserKeys.Login: emailTextField.text!.lowercased(),
                Client.UserKeys.Password: passwordTextField.text!,
                Client.ChatKeys.ResponseType: Client.ChatKeys.AccessToken
            ] as [String: Any]

            if personalServerButton.checkState == .unchecked {
                UserDefaults.standard.set(Client.APIURLs.SusiAPI, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
            } else {
                if let ipAddress = addressTextField.text, !ipAddress.isEmpty && Validator.isIP().apply(ipAddress) || ipAddress.isValidURL() {
                    UserDefaults.standard.set(ipAddress, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
                } else {
                    view.makeToast(ControllerConstants.invalidIP.localized())
                    return
                }
            }

            indicatorView.startAnimating()
            Client.sharedInstance.loginUser(params as [String: AnyObject]) { (user, results, success, message) in
                DispatchQueue.main.async {
                    self.toggleEditing()
                    self.resetDB()
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
            view.makeToast(ControllerConstants.invalidEmailAddress.localized())
        } else if let password = passwordTextField.text, password.isEmpty {
            view.makeToast(ControllerConstants.passwordLengthTooShort.localized())
        }

    }

    func fetchUserSettings(_ accessToken: String) {
        let params = [
            Client.UserKeys.AccessToken: accessToken
        ]

        Client.sharedInstance.fetchUserSettings(params as [String: AnyObject]) { (success, message) in
            DispatchQueue.global().async {
                print("User settings fetch status: \(success) : \(message)")
            }
        }

    }

    // Keyboard Return Key Hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            _ =  passwordTextField.becomeFirstResponder()
        case passwordTextField:
            dismissKeyboard()
            performLogin()
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
        }
    }

    // force dismiss keyboard if open.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // Toggle Editing
    func toggleEditing() {
        emailTextField.isEnabled = !emailTextField.isEnabled
        passwordTextField.isEnabled = !passwordTextField.isEnabled
    }

    // Clear field after login
    func clearFields() {
        passwordTextField.text = ""
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
            if let userData = userDefaultValue as? [String: AnyObject] {
                let user = User(dictionary: userData)
                saveUserGlobally(user: user)

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

    @objc func enterAnonymousMode() {
        resetDB()
        deleteVoiceModel()
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
        let image = ControllerConstants.Images.susiLogo
        susiLogo.image = image
        susiLogo.tintColor = .white
    }

    func saveUserGlobally(user: User) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.currentUser = user
        }
    }

    func resetSettings() {
        UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.enterToSend)
        UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.micInput)
        UserDefaults.standard.set(false, forKey: ControllerConstants.UserDefaultsKeys.hotwordEnabled)
        UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.speechOutput)
        UserDefaults.standard.set(false, forKey: ControllerConstants.UserDefaultsKeys.speechOutputAlwaysOn)
        UserDefaults.standard.set(0.5, forKey: ControllerConstants.UserDefaultsKeys.speechRate)
        UserDefaults.standard.set(1.0, forKey: ControllerConstants.UserDefaultsKeys.speechPitch)
        UserDefaults.standard.set("en", forKey: ControllerConstants.UserDefaultsKeys.prefLanguage)
    }

    func checkIfFileExistsAndReturnPath(fileIdentifier: Int) -> URL? {
        let recordingName = "recordedVoice\(fileIdentifier).wav"

        // Get directory
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        if let path = filePath?.path {
            if FileManager.default.fileExists(atPath: path) {
                return filePath
            }
        }
        return nil
    }

    func deleteVoiceModel() {
        do {
            if let file1 = checkIfFileExistsAndReturnPath(fileIdentifier: 0) {
                try FileManager.default.removeItem(at: file1)
            }
            if let file2 = checkIfFileExistsAndReturnPath(fileIdentifier: 1) {
                try FileManager.default.removeItem(at: file2)
            }
            if let file3 = checkIfFileExistsAndReturnPath(fileIdentifier: 2) {
                try FileManager.default.removeItem(at: file3)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

}
