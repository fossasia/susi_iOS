//
//  ForgotPasswordVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import M13Checkbox
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
        emailTextField.text = UserDefaults.standard.value(forKey: ControllerConstants.UserDefaultsKeys.typedEmailAdress) as? String ?? ""
        emailTextField.textColor = .white
        emailTextField.clearIconButton?.tintColor = .white
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }

    func prepareResetButton() {
        resetButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
    }

    @objc func textFieldDidChange(textField: UITextField) {
        if textField == emailTextField, let emailID = emailTextField.text {
            if !emailID.isValidEmail() {
                emailTextField.dividerActiveColor = .red
            } else {
                emailTextField.dividerActiveColor = .green
            }
        }
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

    func prepareAddressField() {
        addressTextField.placeholderNormalColor = .white
        addressTextField.placeholderActiveColor = .white
        addressTextField.dividerNormalColor = .white
        addressTextField.dividerActiveColor = .white
        addressTextField.textColor = .white
    }

    // Swipe right to go back
    func addRightSwipeGestureToView() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
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
                if let ipAddress = addressTextField.text, !ipAddress.isEmpty && Validator.isIP().apply(ipAddress) {
                    UserDefaults.standard.set(ipAddress, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
                } else {
                    view.makeToast(ControllerConstants.invalidIP.localized())
                    return
                }
            }

            self.toggleEditing()
            self.activityIndicator.startAnimating()

            Client.sharedInstance.recoverPassword(params as [String: AnyObject]) { (_, message) in
                DispatchQueue.main.async {
                    self.toggleEditing()
                    self.activityIndicator.stopAnimating()

                    let errorDialog = UIAlertController(title: ControllerConstants.emailSent.localized(), message: message, preferredStyle: UIAlertControllerStyle.alert)
                    errorDialog.addAction(UIAlertAction(title: ControllerConstants.ok.localized(), style: .cancel, handler: { (_: UIAlertAction!) in
                        errorDialog.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorDialog, animated: true, completion: nil)

                    self.emailTextField.text = ""
                    self.emailTextField.endEditing(true)
                }
            }
        } else {
            self.view.makeToast(ControllerConstants.invalidEmailAddress.localized())
        }

    }

    // Toggle editing
    func toggleEditing() {
        emailTextField.isEnabled = !self.emailTextField.isEnabled
        resetButton.isEnabled = !self.resetButton.isEnabled
    }

    func setupTheme() {
        personalServerButton.secondaryCheckmarkTintColor = UIColor.defaultColor()

        if let navbar = navigationController?.navigationBar {
            navbar.barTintColor = UIColor.defaultColor()
        }
    }

}
