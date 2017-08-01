//
//  ForgotPasswordViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-01.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import DLRadioButton

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var resetButton: FlatButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var personalServerButton: DLRadioButton!
    @IBOutlet weak var addressField: TextField!

    @IBOutlet weak var resetButtonTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareEmailField()
        prepareAddressField()
        prepareResetButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTheme()
    }

}
