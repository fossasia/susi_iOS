//
//  ForgotPasswordViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-01.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: GeneralViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func localizeStrings() {
        title = ControllerConstants.forgotPassword.localized()
    }

}
