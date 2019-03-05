//
//  ResetPasswordVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-11.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

extension ResetPasswordViewController {

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    func setupView() {
        navigationItem.leftViews = [backButton]
        navigationItem.titleLabel.text = ControllerConstants.resetPassword.localized()
        navigationItem.titleLabel.textColor = .white

        if let navbar = navigationController?.navigationBar {
            navbar.barTintColor = UIColor.defaultColor()
        }
    }
    //declare delegate
    func addDelegates() {
        currentPasswordField.delegate = self
        newPasswordField.delegate = self
        confirmPasswordField.delegate = self
    }

    func validatePassword() -> [Bool: String] {
        if let newPassword = newPasswordField.text,
            let confirmPassword = confirmPasswordField.text {
            if newPassword.count > 5 {
                if newPassword == confirmPassword {
                    return [true: ""]
                } else {
                    return [false: ControllerConstants.passwordDoNotMatch.localized()]
                }
            } else {
                return [false: ControllerConstants.passwordLengthShort.localized()]
            }
        }
        return [false: Client.ResponseMessages.ServerError.localized()]
    }

    func setUIActive(active: Bool) {
        isActive = active
        if active {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
        currentPasswordField.isEnabled = !active
        newPasswordField.isEnabled = !active
        confirmPasswordField.isEnabled = !active
    }

    func resetPassword() {
        let checkValidity = validatePassword()
        if let isValid = checkValidity.keys.first,
            let _ = checkValidity.values.first,
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let user = appDelegate.currentUser,
            isValid && !isActive {
            setUIActive(active: true)
            let params = [
                Client.UserKeys.AccessToken: user.accessToken,
                Client.UserKeys.EmailOfAccount: user.emailID,
                Client.UserKeys.Password: currentPasswordField.text ?? "",
                Client.UserKeys.NewPassword: newPasswordField.text ?? ""
            ]

            Client.sharedInstance.resetPassword(params as [String: AnyObject], { (success, message) in
                DispatchQueue.main.async {
                    if success {
                        self.clearField()
                    }
                    self.view.makeToast(message)
                    self.setUIActive(active: false)
                }
            })
        } else {
            view.makeToast(checkValidity.values.first ?? Client.ResponseMessages.PasswordInvalid)
        }
    }

    func clearField() {
        newPasswordField.text = ""
        currentPasswordField.text = ""
        confirmPasswordField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case currentPasswordField:
            newPasswordField.becomeFirstResponder()
        case newPasswordField:
            confirmPasswordField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
}
