//
//  LoginViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import Toast_Swift
import SwiftValidators

class LoginViewController: UIViewController {

    // Setup Susi Logo
    let susiLogo: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: ControllerConstants.Login.susiImage)
        return iv
    }()

    // Setup Email Text Field
    lazy var emailField: AuthTextField = {
        let textField = AuthTextField()
        textField.keyboardType = .emailAddress
        textField.placeholder = ControllerConstants.Login.emailAddress
        textField.detail = ControllerConstants.Login.invalidEmail
        textField.delegate = self
        textField.autocorrectionType = .no
        return textField
    }()

    // Setup Password Field
    lazy var passwordField: AuthTextField = {
        let textField = AuthTextField()
        textField.placeholder = ControllerConstants.Login.password
        textField.detail = ControllerConstants.Login.passwordLengthError
        textField.isVisibilityIconButtonEnabled = true
        textField.visibilityIconButton?.tintColor = Color.white.withAlphaComponent(textField.isSecureTextEntry ? 0.38 : 0.54)
        textField.delegate = self
        return textField
    }()

    // Setup Login Button
    lazy var loginButton: RaisedButton = {
        let button = RaisedButton()
        button.setTitle(ControllerConstants.Login.login, for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.defaultColor(), for: .normal)
        button.addTarget(self, action: #selector(performLogin), for: .touchUpInside)
        return button
    }()

    // Setup Forgot Button
    lazy var forgotButton: FlatButton = {
        let button = FlatButton()
        button.setTitle(ControllerConstants.Login.forgotPassword, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(showFPView), for: .touchUpInside)
        return button
    }()

    // Setup Sign Up Button
    lazy var signUpButton: FlatButton = {
        let button = FlatButton()
        button.setTitle(ControllerConstants.Login.signUpForSusi, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(showSignUpView), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        checkSession()
        addTapGesture()
    }

}
