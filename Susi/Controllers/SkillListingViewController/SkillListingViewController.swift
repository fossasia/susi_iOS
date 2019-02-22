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
    
    lazy var languageButton: UIButton = {
        let button  = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(getToAllLanguageVC), for: .touchUpInside)
        let spacing = 0.5
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor.white
        button.addSubview(line)
        button.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[line]|", metrics: nil, views: ["line":line]))
        button.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(2)]-(\(-spacing))-|", metrics: nil, views: ["line":line]))
        button.setTitle("Select A Language", for: .normal)
        return button
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
    
    weak var chatViewControllerDelegate: ChatViewControllerProtocol?
    
    var shouldShowShimmerLoading: Bool = true
    // stores how many group's data fetched
    var count = 0 {
        didSet {
            if count == groups?.count {
                shouldAnimateIndicators(false)
                shouldShowShimmerLoading = false
                tableView.reloadData()
            }
        }
    }
    
    var skills: Dictionary<String, [Skill]> = [:]
    var presentLangugage: LanguageModel = LanguageModel.getDefaultLanguageModel()

    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .whiteLarge
        indicator.color = UIColor.defaultColor()
        return indicator
    }()

    var selectedSkill: Skill?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareActivityIndicator()
        getAllGroups()
        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
        checkReachability()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.hideAllToasts()
    }
    // MARK: - Table view data source

    func dismissingTheController() {
        if dismissChecker ?? false {
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return groups?.count ?? (shouldShowShimmerLoading ? 4 : 0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "skillListCell", for: indexPath) as? SkillListingTableCell {
            cell.viewModel = SkillListingCellViewModel(skill: skills[groups?[indexPath.row] ?? ""], isLoading: shouldShowShimmerLoading, groupName: groups?[indexPath.row], skillListController: self)
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
        return shouldShowShimmerLoading ? 224.0 : 0.0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let skillDetailVC = segue.destination as? SkillDetailViewController, segue.identifier == ControllerConstants.skillDetailControllerIdentifier {
            skillDetailVC.chatViewControllerDelegate = chatViewControllerDelegate
            skillDetailVC.skill = selectedSkill
        }
    }
}
extension SkillListingViewController: SkillSelectionProtocol {
    //MARK: - SkillSelectionProtocol method
    func didSelectSkill(skill: Skill?) {
        guard let skill = skill else {
            return
        }
        selectedSkill = skill
        performSegue(withIdentifier: ControllerConstants.skillDetailControllerIdentifier, sender: self)
    }
}
