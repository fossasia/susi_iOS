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
import DLRadioButton
import RealmSwift

class LoginViewController: UIViewController {

    let scrollView = UIScrollView()

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

    let standardServerRB: DLRadioButton = {
        let button = DLRadioButton()
        button.setTitle(ControllerConstants.standardServer, for: .normal)
        button.isSelected = true
        return button
    }()

    let customServerRB: DLRadioButton = {
        let button = DLRadioButton()
        button.setTitle(ControllerConstants.customServer, for: .normal)
        return button
    }()

    let customServerAddressField: TextField = {
        let textfield = TextField()
        textfield.placeholderNormalColor = .white
        textfield.placeholderActiveColor = .white
        textfield.dividerNormalColor = .white
        textfield.dividerActiveColor = .white
        textfield.textColor = .white
        textfield.tag = 0
        textfield.placeholder = ControllerConstants.customIPAddress
        return textfield
    }()

    lazy var skip: FlatButton = {
        let button = FlatButton()
        button.setTitle(ControllerConstants.Login.skip, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(anonymousMode), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        checkSession()
        addTapGesture()

        print(Realm.Configuration.defaultConfiguration.fileURL!)
//        let realm = try! Realm()
//        try! realm.write {
//            realm.deleteAll()
//        }
    }

}
