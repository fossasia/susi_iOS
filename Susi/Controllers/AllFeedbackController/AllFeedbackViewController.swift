//
//  AllFeedbackViewController.swift
//  Susi
//
//  Created by JOGENDRA on 28/06/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class AllFeedbackViewController: UITableViewController {

    lazy var backButton: IconButton = {
        let button = IconButton()
        button.image = Icon.cm.arrowBack
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()

    var feedbacks: [Feedback]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
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
        return feedbacks?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableFooterView = UIView(frame: .zero)
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AllFeedbackCell", for: indexPath) as? AllFeedbackCell {
            cell.feedback = feedbacks?[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let feedbacks = feedbacks {
            let estimatedLabelHeight = UILabel().heightForLabel(text: feedbacks[indexPath.row].feedbackString, font: UIFont.systemFont(ofSize: 14.0), width: 250.0)
            return 64 + estimatedLabelHeight
        } else {
            return 80
        }
    }

}
