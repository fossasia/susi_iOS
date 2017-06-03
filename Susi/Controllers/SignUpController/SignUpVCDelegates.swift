//
//  SignUpVCDelegates.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

extension SignUpViewController: TextFieldDelegate {

    // Verify input data after editing over
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let emailID = emailField.text, !emailID.isValidEmail() && textField == emailField {
            emailField.isErrorRevealed = true
        } else {
            emailField.isErrorRevealed = false
        }

        if let password = passwordField.text, password.isEmpty && textField == passwordField && password.characters.count < 6 {
            passwordField.isErrorRevealed = true
        } else {
            passwordField.isErrorRevealed = false
        }
    }

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }

}
