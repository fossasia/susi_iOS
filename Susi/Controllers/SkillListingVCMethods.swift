//
//  SkillListingVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-24.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

extension SkillListingViewController {

    // setup view
    func setupView() {
        navigationItem.title = ControllerConstants.skillListing
        navigationItem.titleLabel.textAlignment = .left
        navigationItem.leftViews = [backButton]
        navigationItem.rightViews = [settingsButton]
        navigationItem.titleLabel.textColor = .white
        if let navbar = navigationController?.navigationBar {
            navbar.barTintColor = UIColor.defaultColor()
        }

        tableView.separatorStyle = .none
    }

    // presents the settings controller
    func presentSettingsController() {
        let vc = ControllerConstants.Controllers.settingsController
        let nvc = AppNavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }

    // dismiss controller
    func dismissController() {
        motionDismissViewController()
    }

    // get all groups
    func getAllGroups() {
        Client.sharedInstance.getAllGroups { (groups, success, message) in
            DispatchQueue.main.async {
                if success {
                    self.groups = groups
                    self.tableView.reloadData()
                } else {
                    print(message ?? "error")
                }
            }
        }
    }

}
