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

class ResetPasswordViewController: UITableViewController, UITextFieldDelegate {

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
    @IBOutlet weak var resetPasswordFLabel: UILabel!

    var isActive = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(localizeStrings),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
        localizeStrings()
        addDelegates()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            resetPassword()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @objc func localizeStrings() {
        currentPasswordFLabel.text = ControllerConstants.currentPassword.localized()
        newPasswordFLabel.text = ControllerConstants.newPassword.localized()
        confirmPasswordFLabel.text = ControllerConstants.SignUp.confirmPassword.localized()
        resetPasswordFLabel.text = ControllerConstants.resetPassword.localized()
    }
}
