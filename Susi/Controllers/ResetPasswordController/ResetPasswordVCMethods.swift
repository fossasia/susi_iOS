//
//  ResetPasswordVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-11.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

extension ResetPasswordViewController {

    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    func setupView() {
        navigationItem.leftViews = [backButton]
        navigationItem.title = "Reset Password"
        navigationItem.titleLabel.textColor = .white

        guard let navBar = navigationController?.navigationBar as? NavigationBar else {
            return
        }
        navBar.backgroundColor = UIColor.hexStringToUIColor(hex: "#4184F3")
    }

}
