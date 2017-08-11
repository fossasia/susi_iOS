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

    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            // check and make API call
        }
    }

}
