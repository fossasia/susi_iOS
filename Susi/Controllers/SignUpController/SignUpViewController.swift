//
//  SignUpViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import M13Checkbox

class SignUpViewController: GeneralViewController {

    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var confirmPasswordTextField: TextField!
    @IBOutlet weak var signUpButton: RaisedButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var personalServerButton: M13Checkbox!
    @IBOutlet weak var addressTextField: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
        prepareFields()
        prepareSignUpButton()
    }
    override func localizeStrings() {
        emailTextField.placeholder = ControllerConstants.Login.emailAddress.localized()
        passwordTextField.placeholder = ControllerConstants.Login.password.localized()
        confirmPasswordTextField.placeholder = ControllerConstants.SignUp.confirmPassword.localized()
        signUpButton.setTitle(ControllerConstants.SignUp.signUp.localized().uppercased(), for: .normal)
        addressTextField.placeholder = ControllerConstants.customServerURL.localized()
    }

}
