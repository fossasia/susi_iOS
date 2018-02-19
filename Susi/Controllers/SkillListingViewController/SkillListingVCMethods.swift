//
//  SkillListingVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-24.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

extension SkillListingViewController {
    
    // setup view
    func setupView() {
        navigationItem.titleLabel.text = ControllerConstants.skillListing.localized()
        navigationItem.titleLabel.textAlignment = .left
        navigationItem.leftViews = [backButton]
        navigationItem.rightViews = [settingsButton]
        navigationItem.titleLabel.textColor = .white
        if let navbar = navigationController?.navigationBar {
            navbar.barTintColor = UIColor.defaultColor()
        }
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = Color.grey.lighten3
    }
    
    // presents the settings controller
    func presentSettingsController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SettingsController")
        let nvc = AppNavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }
    
    // dismiss controller
    func dismissController() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // setup activity indicator
    func prepareActivityIndicator() {
        tableView.layout(activityIndicator).center()
    }
    
    // get all groups
    func getAllGroups() {
        activityIndicator.startAnimating()
        Client.sharedInstance.getAllGroups { (groups, success, message) in
            DispatchQueue.main.async {
                if success {
                    self.groups = groups
                    self.getAllSkills()
                } else {
                    print(message ?? "error")
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    // get all skills and save them inside a list
    func getAllSkills() {
        if let groups = groups {
            for group in groups {
                
                let params = [
                    Client.SkillListing.group: group
                ]
                
                getSkillData(params: params as [String : AnyObject], group: group)
            }
        }
    }
    
    func getSkillData(params: [String:AnyObject], group: String) {
        // sleep 0.3 seconds to bypass server request failure
        usleep(300000)
        Client.sharedInstance.getSkillData(params, { (skill, success, _) in
            DispatchQueue.main.async {
                if success {
                    self.skills[group] = skill
                } else {
                    self.skills[group] = nil
                }
                self.count += 1
            }
        })
    }
    
}

