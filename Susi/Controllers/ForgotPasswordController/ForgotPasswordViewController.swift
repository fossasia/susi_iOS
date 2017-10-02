//
//  ForgotPasswordViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-01.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import M13Checkbox

class ForgotPasswordViewController: GeneralViewController {

    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var resetButton: FlatButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var personalServerButton: M13Checkbox!
    @IBOutlet weak var addressTextField: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareEmailField()
        prepareAddressField()
        prepareResetButton()
        setupTheme()
    }
    override func localizeStrings() {
        navigationItem.titleLabel.text = ControllerConstants.forgotPassword.localized()
        title = ControllerConstants.forgotPassword.localized()
        emailTextField.placeholder = ControllerConstants.Login.emailAddress.localized()
        addressTextField.placeholder = ControllerConstants.customServerURL.localized()
        resetButton.setTitle(ControllerConstants.reset.localized(), for: .normal)
    }

}
