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

    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    func setupView() {
        navigationItem.leftViews = [backButton]
        navigationItem.title = ControllerConstants.resetPassword
        navigationItem.titleLabel.textColor = .white

        guard let navBar = navigationController?.navigationBar as? NavigationBar else {
            return
        }
        navBar.backgroundColor = UIColor.hexStringToUIColor(hex: "#4184F3")
    }

    func validatePassword() -> [Bool:String] {
        if let newPassword = newPasswordField.text,
            let confirmPassword = confirmPasswordField.text {
            if newPassword.characters.count > 5 {
                if newPassword == confirmPassword {
                    return [true: ""]
                } else {
                    return [false: ControllerConstants.passwordDoNotMatch]
                }
            } else {
                return [false: ControllerConstants.passwordLengthShort]
            }
        }
        return [false: Client.ResponseMessages.ServerError]
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

}
