//
//  DeviceInstructionsViewController.swift
//  Susi
//
//  Created by JOGENDRA on 28/05/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class DeviceInstructionsViewController: UIViewController {

    lazy var backButton: IconButton = {
        let button = IconButton()
        button.image = Icon.cm.arrowBack
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
    }

    // Setup Navigation Bar
    func setupTitle() {
        navigationItem.titleLabel.text = ControllerConstants.addNewDevice.localized()
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

}
