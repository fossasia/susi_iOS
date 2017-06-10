//
//  ForgotPasswordVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import DLRadioButton

extension ForgotPasswordViewController {

    func setupView() {
        self.view.backgroundColor = UIColor.defaultColor()

        if let navController = self.navigationController {
            navController.navigationBar.backgroundColor = UIColor.navBarColor()
            navigationItem.titleLabel.text = ControllerConstants.forgotPassword
            navigationItem.titleLabel.textColor = .white
            navigationItem.leftViews = [dismissButton]
        }
    }

    // Dismiss View
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    // Add Subview Email Field
    func prepareEmailField() {
        self.view.addSubview(emailField)
        self.view.layout(emailField)
            .top(UIView.UIMarginSpec.largeMatgin)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
        self.view.layoutSubviews()
    }

    func prepareRadioButtons() {
        self.view.addSubview(standardServerRB)
        self.view.layout(standardServerRB)
            .top(emailField.frame.maxY + UIView.UIMarginSpec.mediumMargin)
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
                self.resetButton.frame.origin.y = self.customServerAddressField.frame.minY
            } else {
                self.resetButton.frame.origin.y = self.customServerAddressField.frame.maxY + UIView.UIMarginSpec.mediumMargin
            }
            self.activityIndicator.frame.origin.y = self.resetButton.frame.maxY + UIView.UIMarginSpec.mediumMargin
            self.view.layoutIfNeeded()
        }
    }

    // Add Subview Reset Button
    func prepareResetButton() {
        self.view.addSubview(resetButton)
        self.view.layout(resetButton)
            .height(44)
            .top(customServerAddressField.frame.minY)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
        self.view.layoutSubviews()
    }

    // Add Subview Activity Indicator
    func prepareActivityIndicator() {
        self.view.addSubview(activityIndicator)
        self.view.layout(activityIndicator)
            .top(resetButton.frame.maxY + UIView.UIMarginSpec.mediumMargin)
            .centerHorizontally()
    }

    // Call Reset Password API
    func resetPassword() {

        if let emailID = emailField.text, !emailID.isEmpty && emailID.isValidEmail() {

            let params = [
                Client.UserKeys.ForgotEmail: emailField.text?.lowercased()
            ]

            self.emailField.isErrorRevealed = false
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

                    self.emailField.text = ""
                    self.emailField.endEditing(true)
                }
            }

        } else {
            emailField.isErrorRevealed = true
        }

    }

    // Toggle editing
    func toggleEditing() {
        self.emailField.isEnabled = !self.emailField.isEnabled
        self.resetButton.isEnabled = !self.resetButton.isEnabled
    }

}
