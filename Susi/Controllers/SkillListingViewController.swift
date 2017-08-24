//
//  SkillListingViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-24.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class SkillListingViewController: UITableViewController {

    // for opening settings view controller
    lazy var settingsButton: IconButton = {
        let ib = IconButton()
        ib.image = Icon.moreVertical
        ib.tintColor = .white
        ib.cornerRadius = 18.0
        ib.addTarget(self, action: #selector(presentSettingsController), for: .touchUpInside)
        return ib
    }()

    // for opening settings view controller
    lazy var backButton: IconButton = {
        let ib = IconButton()
        ib.image = Icon.arrowBack
        ib.tintColor = .white
        ib.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        return ib
    }()

    var groups: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        getAllGroups()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupView()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? SkillListingTableCell {
            cell.groupName = groups?[indexPath.row]
            return cell
        }

        return UITableViewCell()
    }

}
