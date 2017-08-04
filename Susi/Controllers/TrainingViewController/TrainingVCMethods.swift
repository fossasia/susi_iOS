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
        guard let navBar = navigationController?.navigationBar as? NavigationBar else {
            return
        }

        let activeTheme = UserDefaults.standard.string(forKey: ControllerConstants.UserDefaultsKeys.theme)
        if activeTheme == theme.light.rawValue {
            navBar.backgroundColor = UIColor.hexStringToUIColor(hex: "#4184F3")
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.hexStringToUIColor(hex: "#4184F3")
        } else if activeTheme == theme.dark.rawValue {
            navBar.backgroundColor = UIColor.defaultColor()
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.defaultColor()
        }
    }

    func addCancelNavItem() {
        navigationItem.title = ControllerConstants.Settings.trainHotword
        navigationItem.titleLabel.textColor = .white

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped(_:)))
        cancelButton.tintColor = .white
        navigationItem.rightBarButtonItems = [cancelButton]
    }

    func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func setupUI() {
        stopRecordButton.isEnabled = false
    }

}
