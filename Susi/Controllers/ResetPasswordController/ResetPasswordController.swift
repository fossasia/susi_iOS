//
//  ResetPasswordViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-11.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import Localize_Swift

class ResetPasswordViewController: UIViewController {

    lazy var backButton: IconButton = {
        let button = IconButton()
        button.image = Icon.arrowBack
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()

    @IBOutlet weak var currentPasswordField: CustomTextField!
    @IBOutlet weak var newPasswordField: CustomTextField!
    @IBOutlet weak var confirmPasswordField: CustomTextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var currentPasswordFLabel: UILabel!
    @IBOutlet weak var newPasswordFLabel: UILabel!
    @IBOutlet weak var confirmPasswordFLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: UIButton!


    var isActive = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(localizeStrings),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
        localizeStrings()
    }

    @IBAction func didResetPassword(_ sender: Any) {
        resetPassword()
    }


    @objc func localizeStrings() {
        currentPasswordFLabel.text = ControllerConstants.currentPassword.localized()
        newPasswordFLabel.text = ControllerConstants.newPassword.localized()
        confirmPasswordFLabel.text = ControllerConstants.SignUp.confirmPassword.localized()
        resetPasswordButton.setTitle(ControllerConstants.resetPassword.localized(), for: .normal)
    }
}
