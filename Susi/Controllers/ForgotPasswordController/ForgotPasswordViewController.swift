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

}
