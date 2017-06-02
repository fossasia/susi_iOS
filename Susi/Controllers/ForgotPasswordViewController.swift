//
//  ForgotPasswordViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-01.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class ForgotPasswordViewController: UIViewController {

    // Setup Dismiss Button
    lazy var dismissButton: IconButton = {
        let ib = IconButton()
        ib.image = Icon.cm.arrowBack
        ib.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        ib.tintColor = .white
        return ib
    }()

    // Setup Email Text Field
    lazy var emailField: AuthTextField = {
        let textField = AuthTextField()
        textField.keyboardType = .emailAddress
        textField.placeholder = ControllerConstants.enterEmailID
        textField.detailLabel.text = ControllerConstants.invalidEmail
        textField.delegate = self
        return textField
    }()

    // Setup Reset Button
    lazy var resetButton: RaisedButton = {
        let button = RaisedButton()
        button.setTitle(ControllerConstants.reset, for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.defaultColor(), for: .normal)
        button.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        return button
    }()

    // Setup Activity Indicator
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        ai.hidesWhenStopped = true
        ai.activityIndicatorViewStyle = .whiteLarge
        return ai
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        prepareEmailField()
        prepareResetButton()
        prepareActivityIndicator()
    }

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
    private func prepareEmailField() {
        self.view.addSubview(emailField)
        self.view.layout(emailField)
            .top(UIView.UIMarginSpec.largeMatgin)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
    }

    // Add Subview Reset Button
    private func prepareResetButton() {
        self.view.addSubview(resetButton)
        self.view.layout(resetButton)
            .height(44)
            .top(emailField.height + 70)
            .left(UIView.UIMarginSpec.mediumMargin)
            .right(UIView.UIMarginSpec.mediumMargin)
    }

    // Add Subview Activity Indicator
    private func prepareActivityIndicator() {
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

extension ForgotPasswordViewController: TextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailField.isErrorRevealed = false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resetPassword()
        return true
    }

}
