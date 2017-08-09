//
//  SettingsViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-15.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class SettingsViewController: UITableViewController {

    // Get directory
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

    lazy var backButton: IconButton = {
        let button = IconButton()
        button.image = Icon.arrowBack
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()

    // Image Picker Controller
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTheme()
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = UIColor.hexStringToUIColor(hex: "#009688")
        }
    }

}
