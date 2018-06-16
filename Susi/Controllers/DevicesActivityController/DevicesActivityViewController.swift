//
//  DevicesActivityViewController.swift
//  Susi
//
//  Created by JOGENDRA on 29/05/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class DevicesActivityViewController: UIViewController {

    lazy var backButton: IconButton = {
        let button = IconButton()
        button.image = Icon.cm.arrowBack
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()

    lazy var addDeviceButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle(ControllerConstants.addNewDevice.uppercased(), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.defaultColor()
        button.tintColor = .white
        button.layer.cornerRadius = 8.0
        button.setImage(ControllerConstants.Images.plusIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.clipsToBounds = true
        button.centerTextAndImage(spacing: 0.5)
        button.addTarget(self, action: #selector(presentInstructionController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    @IBOutlet weak var noDeviceInfoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        addRightSwipeGestureToView()
        setupTitle()
        setupAddDeviceButton()
    }

    // Setup Navigation Bar
    func setupTitle() {
        navigationItem.titleLabel.text = ControllerConstants.devices.localized()
        navigationItem.titleLabel.textAlignment = .left
        navigationItem.titleLabel.textColor = .white
        navigationItem.leftViews = [backButton]
        if let navbar = navigationController?.navigationBar {
            navbar.barTintColor = UIColor.defaultColor()
        }
    }

    func setupAddDeviceButton() {
        view.addSubview(addDeviceButton)
        addDeviceButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32.0).isActive = true
        addDeviceButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32.0).isActive = true
        addDeviceButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        addDeviceButton.topAnchor.constraint(equalTo: noDeviceInfoLabel.topAnchor, constant: 32).isActive = true
    }

    // Swipe right to go back
    func addRightSwipeGestureToView() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func presentInstructionController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let deviceInstructionsViewController = storyboard.instantiateViewController(withIdentifier: "DeviceInstructionsViewController")
        let nvc = AppNavigationController(rootViewController: deviceInstructionsViewController)
        present(nvc, animated: true, completion: nil)
    }

}
