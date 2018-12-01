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
        tableView.backgroundColor = Color.grey.lighten4
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = UIColor.defaultColor()
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }

    // presents the settings controller
    @objc func presentSettingsController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SettingsController")
        let nvc = AppNavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }

    // dismiss controller
    @objc func dismissController() {
        navigationController?.dismiss(animated: true, completion: nil)
        // In-case of 3D-touch home action
        if let chatVC = self.chatViewController {
            present(chatVC, animated: true, completion: nil)
        }
    }

    // setup activity indicator
    func prepareActivityIndicator() {
        tableView.layout(activityIndicator).center()
    }

    func shouldAnimateIndicators(_ animate: Bool) {
        DispatchQueue.main.async {
            if(animate) {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }

    // get all groups
    func getAllGroups() {
        Client.sharedInstance.getAllGroups { (groups, success, message) in
            DispatchQueue.main.async {
                if success {
                    self.groups = groups
                    self.getAllSkills()
                } else {
                    print(message ?? "error")
                    self.shouldAnimateIndicators(false)
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
    @objc func pullToRefresh() {
        if(!self.activityIndicator.isAnimating) {
            self.count = 0
            getAllGroups()
        } else {
            shouldAnimateIndicators(false)
        }
    }

    func getSkillData(params: [String: AnyObject], group: String) {
        // sleep 0.3 seconds to bypass server  request failure
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
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

    func checkReachability() {
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                let noConnection = noConnectionViewController()
                let view = UINavigationController(rootViewController: noConnection)
                self.present(view, animated: true, completion: {
                    noConnection.skillListingInstance = self
                })
            }
            self.dismissingTheController()
        }
    }

}
