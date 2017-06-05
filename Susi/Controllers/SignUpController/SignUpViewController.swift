//
//  SignUpViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class SignUpViewController: UIViewController {

    // Setup Dismiss Button
    let dismissButton: IconButton = {
        let ib = IconButton()
        ib.image = Icon.cm.arrowBack
        ib.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        ib.tintColor = .white
        return ib
    }()

    // Setup Email Field
    lazy var emailField: AuthTextField = {
        let textField = AuthTextField()
        textField.keyboardType = .emailAddress
        textField.placeholder = ControllerConstants.SignUp.emailAddress
        textField.detail = ControllerConstants.SignUp.invalidEmail
        textField.delegate = self
        return textField
    }()

    // Setup Password Field
    lazy var passwordField: AuthTextField = {
        let textField = AuthTextField()
        textField.placeholder = ControllerConstants.SignUp.password
        textField.detailLabel.text = ControllerConstants.SignUp.passwordError
        textField.clearButtonMode = .whileEditing
        textField.isVisibilityIconButtonEnabled = true
        textField.visibilityIconButton?.tintColor = Color.white.withAlphaComponent(textField.isSecureTextEntry ? 0.38 : 0.54)
        textField.delegate = self
        return textField
    }()

    // Setup Confirm Password Field
    lazy var confirmPasswordField: AuthTextField = {
        let textField = AuthTextField()
        textField.placeholder = ControllerConstants.SignUp.confirmPassword
        textField.detail = ControllerConstants.SignUp.passwordDoNotMatch
        textField.clearIconButton?.tintColor = .white
        textField.clearButtonMode = .whileEditing
        textField.isVisibilityIconButtonEnabled = true
        textField.visibilityIconButton?.tintColor = Color.white.withAlphaComponent(textField.isSecureTextEntry ? 0.38 : 0.54)
        textField.delegate = self
        return textField
    }()

    // Setup Sign Up Button
    lazy var signUpButton: RaisedButton = {
        let button = RaisedButton()
        button.setTitle(ControllerConstants.SignUp.signUp, for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.defaultColor(), for: .normal)
        button.addTarget(self, action: #selector(performSignUp), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addTapGesture()
    }

}
