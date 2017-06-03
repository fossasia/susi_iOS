//
//  ForgotPasswordVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

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
    }

    // Add Subview Reset Button
    func prepareResetButton() {
        self.view.addSubview(resetButton)
        self.view.layout(resetButton)
            .height(44)
            .top(emailField.height + 70)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
    }

    // Add Subview Activity Indicator
    func prepareActivityIndicator() {
        self.view.addSubview(activityIndicator)
        self.view.layout(activityIndicator)
            .top(resetButton.frame.maxY + 170)
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
