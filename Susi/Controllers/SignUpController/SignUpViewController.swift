//
//  SignUpViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import DLRadioButton

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var confirmPasswordTextField: TextField!
    @IBOutlet weak var addressTextField: TextField!
    @IBOutlet weak var signUpButton: RaisedButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var standardServerButton: DLRadioButton!
    @IBOutlet weak var personalServerButton: DLRadioButton!

    @IBOutlet weak var signUpButtonTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        addTapGesture()
        prepareFields()
        prepareSignUpButton()
    }

}
