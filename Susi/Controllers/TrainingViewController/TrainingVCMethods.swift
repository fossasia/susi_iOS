//
//  TrainingVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

extension TrainingViewController {

    func setupNavBar() {
        if let navbar = navigationController?.navigationBar {
            navbar.barTintColor = UIColor.defaultColor()
        }
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.defaultColor()
    }

    func addCancelNavItem() {
        navigationItem.titleLabel.text = ControllerConstants.trainHotword.localized()
        navigationItem.titleLabel.textColor = .white

        let cancelButton = UIBarButtonItem(title: ControllerConstants.dialogCancelAction.localized(),
                                           style: .plain,
                                           target: self,
                                           action: #selector(cancelTapped(_:)))
        cancelButton.tintColor = .white
        navigationItem.rightBarButtonItems = [cancelButton]
    }

    @objc func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func addTargets() {
        finishLaterButton.addTarget(self, action: #selector(cancelTapped(_:)), for: .touchUpInside)
    }

}
