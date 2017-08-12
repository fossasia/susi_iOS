//
//  ResetPasswordViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-11.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class ResetPasswordViewController: UITableViewController {

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

    var isActive = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let checkValidity = validatePassword()
            if let isValid = checkValidity.keys.first,
                let message = checkValidity.values.first {
                if isValid {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    setUIActive(active: true)
                    if let user = appDelegate.currentUser, isActive {
                        let params = [
                            Client.UserKeys.AccessToken: user.accessToken,
                            Client.UserKeys.EmailOfAccount: user.emailID,
                            Client.UserKeys.Password: currentPasswordField.text ?? "",
                            Client.UserKeys.NewPassword: newPasswordField.text ?? ""
                        ]

                        Client.sharedInstance.resetPassword(params as [String : AnyObject], { (_, message) in
                            DispatchQueue.main.async {
                                self.view.makeToast(message)
                                self.setUIActive(active: false)
                            }
                        })
                    }
                } else {
                    view.makeToast(message)
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
