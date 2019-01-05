//
//  SkillListingViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-24.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import Reachability

class SkillListingViewController: UITableViewController {

    // for opening settings view controller

    let reachability = Reachability()!
    var dismissChecker: Bool?

    lazy var settingsButton: IconButton = {
        let ib = IconButton()
        ib.image = Icon.moreVertical
        ib.tintColor = .white
        ib.layer.cornerRadius = 18.0
        ib.addTarget(self, action: #selector(presentSettingsController), for: .touchUpInside)
        return ib
    }()

    // for opening settings view controller
    lazy var backButton: IconButton = {
        let ib = IconButton()
        ib.image = Icon.cm.arrowBack
        ib.tintColor = .white
        ib.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        return ib
    }()

    var groups: [String]?

    var chatViewController: ChatViewController?

    // stores how many group's data fetched
    var count = 0 {
        didSet {
            if count == groups?.count {
                shouldAnimateIndicators(false)
                tableView.reloadData()
            }
        }
    }
    var skills = [String: [Skill]]()

    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .whiteLarge
        indicator.color = UIColor.defaultColor()
        return indicator
    }()

    var selectedSkill: Skill? {
        didSet {
            performSegue(withIdentifier: ControllerConstants.skillDetailControllerIdentifier, sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        prepareActivityIndicator()
        shouldAnimateIndicators(true)
        getAllGroups()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.setupView()
        checkReachability()
    }

    // MARK: - Table view data source

    func dismissingTheController() {
        if dismissChecker ?? false {

            self.dismiss(animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return groups?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "skillListCell", for: indexPath) as? SkillListingTableCell,
            let group = groups?[indexPath.row] {
            cell.groupName = group
            cell.skillListController = self
            cell.skills = skills[group]
            return cell
        }
        return UITableViewCell()
    }

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(internetConnection), name: Notification.Name.reachabilityChanged, object: reachability)

        do {
            try reachability.startNotifier()
        } catch {
            print(error)
        }
    }

    @objc func internetConnection(notification: NSNotification) {
        guard let reachability = notification.object as? Reachability else {return}
        if reachability.connection != .none {
            print("internet is available")
        } else {

            print("internet is not available")
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let group = groups?[indexPath.row], let skills = self.skills[group] {
            if skills.count > 0 {
                return 224.0
            }
        }
        return 0.0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SkillDetailViewController, segue.identifier == ControllerConstants.skillDetailControllerIdentifier {
            vc.chatViewController = chatViewController
            vc.skill = selectedSkill
        }
    }
}
