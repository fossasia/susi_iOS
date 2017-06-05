//
//  ForgotPasswordVCDelegates.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

extension ForgotPasswordViewController: TextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailField.isErrorRevealed = false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resetPassword()
        return true
    }

}
