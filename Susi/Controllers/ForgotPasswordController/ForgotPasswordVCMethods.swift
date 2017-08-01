//
//  ForgotPasswordVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import DLRadioButton
import SwiftValidators
import Material

extension ForgotPasswordViewController {

    // Dismiss View
    @IBAction func dismissView() {
        dismiss(animated: true, completion: nil)
    }

    // Configures Email Field
    func prepareEmailField() {
        emailTextField.placeholderNormalColor = .white
        emailTextField.placeholderActiveColor = .white
        emailTextField.dividerNormalColor = .white
        emailTextField.dividerActiveColor = .red
        emailTextField.textColor = .white
        emailTextField.clearIconButton?.tintColor = .white
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }

    func prepareResetButton() {
        resetButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
    }

    func textFieldDidChange(textField: UITextField) {
        if textField == emailTextField, let emailID = emailTextField.text {
            if !emailID.isValidEmail() {
                emailTextField.dividerActiveColor = .red
            } else {
                emailTextField.dividerActiveColor = .green
            }
        }
    }

    @IBAction func toggleRadioButtons(_ sender: Any) {
        if let button = sender as? DLRadioButton {
            button.isSelected = button.tag == 0 ? true : false
            if button.isSelected {
                addressField.tag = 1
                button.tag = 1
            } else {
                addressField.tag = 0
                button.tag = 0
            }
            toggleAddressFieldDisplay()
        }
    }

    func toggleAddressFieldDisplay() {
        UIView.animate(withDuration: 0.5) {
            if self.addressField.tag == 1 {
                self.resetButtonTopConstraint.constant = 67
            } else {
                self.resetButtonTopConstraint.constant = 24
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
    }

    // Call Reset Password API
    func resetPassword() {

        if let emailID = emailTextField.text, !emailID.isEmpty && emailID.isValidEmail() {

            var params = [
                Client.UserKeys.ForgotEmail: emailTextField.text?.lowercased()
            ]

            if !personalServerButton.isSelected {
                UserDefaults.standard.set(Client.APIURLs.SusiAPI, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
            } else {
                if let ipAddress = addressField.text, !ipAddress.isEmpty && Validator.isIP().apply(ipAddress) {
                    UserDefaults.standard.set(ipAddress, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
                } else {
                    view.makeToast("Invalid IP Address")
                    return
                }
            }

            self.toggleEditing()
            self.activityIndicator.startAnimating()

            Client.sharedInstance.resetPassword(params as [String : AnyObject]) { (_, message) in
                DispatchQueue.main.async {
                    self.toggleEditing()
                    self.activityIndicator.stopAnimating()

                    let errorDialog = UIAlertController(title: ControllerConstants.emailSent, message: message, preferredStyle: UIAlertControllerStyle.alert)
                    errorDialog.addAction(UIAlertAction(title: ControllerConstants.ok, style: .cancel, handler: { (_: UIAlertAction!) in
                        errorDialog.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorDialog, animated: true, completion: nil)

                    self.emailTextField.text = ""
                    self.emailTextField.endEditing(true)
                }
            }
            params.removeAll()
        } else {
            self.view.makeToast("Invalid email address")
        }

    }

    // Toggle editing
    func toggleEditing() {
        emailTextField.isEnabled = !self.emailTextField.isEnabled
        resetButton.isEnabled = !self.resetButton.isEnabled
    }

    func setupTheme() {
        UIApplication.shared.statusBarStyle = .lightContent
        let activeTheme = UserDefaults.standard.string(forKey: ControllerConstants.UserDefaultsKeys.theme)
        if activeTheme == theme.light.rawValue {
            view.backgroundColor = UIColor.hexStringToUIColor(hex: "#4184F3")
        } else if activeTheme == theme.dark.rawValue {
            view.backgroundColor = UIColor.defaultColor()
        }

        if let navbar = navigationController?.navigationBar {
            if activeTheme == theme.light.rawValue {
                navbar.barTintColor = UIColor.hexStringToUIColor(hex: "#4184F3")
            } else if activeTheme == theme.dark.rawValue {
                navbar.barTintColor = UIColor.defaultColor()
            }
        }

    }

}
