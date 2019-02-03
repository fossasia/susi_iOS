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
        navigationItem.rightViews = [languageButton, settingsButton]
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
    //MARK: - Presents All Language VC
     @objc func getToAllLanguageVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: SelectLanguageViewController.self)) as? SelectLanguageViewController
        weak var weakSelf = self
        vc?.languageSelection = {
            languageModel in
            weakSelf?.count = 0
            weakSelf?.presentLangugage = languageModel
            weakSelf?.getAllGroups()
            weakSelf?.shouldShowShimmerLoading = true
            weakSelf?.tableView.reloadData()
        }
        let nvc = AppNavigationController(rootViewController: vc!)
        present(nvc, animated: true, completion: nil)
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
    }
    
    // setup activity indicator
    func prepareActivityIndicator() {
        tableView.layout(activityIndicator).center()
    }
    
    func shouldAnimateIndicators(_ animate: Bool) {
        weak var weakSelf = self
        DispatchQueue.main.async {
            if(animate) {
                weakSelf?.activityIndicator.startAnimating()
            } else {
                weakSelf?.activityIndicator.stopAnimating()
                weakSelf?.tableView.refreshControl?.endRefreshing()
                if((weakSelf?.skills.isEmpty) ?? false && weakSelf?.reachability.connection != .none) {
                    weakSelf?.view.makeToast(ControllerConstants.noResultFound.localized(), duration: 1000000
                        , completion: { (didTap) in
                            if(didTap) {
                                weakSelf?.getToAllLanguageVC()
                            }
                    })
                }
            }
        }
    }
    
    // get all groups
    func getAllGroups() {
        languageButton.setTitle(presentLangugage.languageName, for: .normal)
        let parameter = [Client.SkillListing.language: presentLangugage.languageCode]
        Client.sharedInstance.getAllGroups(parameter: parameter as [String : AnyObject]) { (groups, success, message) in
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
                    Client.SkillListing.group: group,
                    Client.SkillListing.language: presentLangugage.languageCode
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
        weak var weakSelf = self
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                let noConnection = noConnectionViewController()
                let view = UINavigationController(rootViewController: noConnection)
                weakSelf?.present(view, animated: true, completion: {
                    noConnection.skillListingInstance = weakSelf
                })
            }
            weakSelf?.dismissingTheController()
        }
    }
}
