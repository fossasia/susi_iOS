//
//  AllFeedbackViewController.swift
//  Susi
//
//  Created by JOGENDRA on 28/06/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class AllFeedbackViewController: UITableViewController, UISearchBarDelegate {

    lazy var backButton: IconButton = {
        let button = IconButton()
        button.image = Icon.cm.arrowBack
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()

    var feedbacks: [Feedback]?
    var searchFeedbacks: [Feedback]?

    @IBOutlet weak var userSearchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setUpSearchBar()
    }

    // Setup Navigation Bar
    func setupTitle() {
        navigationItem.titleLabel.text = ControllerConstants.skillFeedback.localized()
        navigationItem.titleLabel.textAlignment = .left
        navigationItem.titleLabel.textColor = .white
        navigationItem.leftViews = [backButton]
        if let navbar = navigationController?.navigationBar {
            navbar.barTintColor = UIColor.defaultColor()
        }
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchFeedbacks?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableFooterView = UIView(frame: .zero)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllFeedbackCell") as? AllFeedbackCell else  {
            return UITableViewCell()
        }
        cell.feedback = searchFeedbacks?[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let feedbacks = feedbacks {
            let estimatedLabelHeight = UILabel().heightForLabel(text: feedbacks[indexPath.row].feedbackString, font: UIFont.systemFont(ofSize: 14.0), width: 250.0)
            return 64 + estimatedLabelHeight
        } else {
            return 80
        }
    }
    
    func setUpSearchBar() {
        userSearchBar.delegate = self
        userSearchBar.placeholder = ControllerConstants.userSearch
        searchFeedbacks = feedbacks
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchFeedbacks = feedbacks?.filter({ (searchFeedbacks) -> Bool in
            if searchText.isEmpty { return true }
            let username = searchFeedbacks.username
            if !(username?.isEmpty)! {
                return (searchFeedbacks.username?.lowercased().contains(searchText.lowercased()))!
            } else {
                return (searchFeedbacks.email.lowercased().contains(searchText.lowercased()))
            }
        })
        tableView.reloadData()
    }

}
