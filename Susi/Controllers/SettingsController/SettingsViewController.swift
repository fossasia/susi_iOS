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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row

        if section == 3 {
            if row == 0 {
                themeToggleAlert()
            }
        } else if section == 4 {
            if row == 0 {
                presentTrainingController()
            } else if row == 1 {
                deleteVoiceModel()
            }
        } else if section == 5 {
            if row == 3 {
                logoutUser()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = UserDefaults.standard.dictionary(forKey: ControllerConstants.UserDefaultsKeys.user)
        if indexPath.section == 5 && indexPath.row == 2 && user == nil {
            cell.isHidden = true
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let user = UserDefaults.standard.dictionary(forKey: ControllerConstants.UserDefaultsKeys.user)
        if indexPath.section == 5 && indexPath.row == 2 && user == nil {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

}
