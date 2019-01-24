//
//  SettingsViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-15.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import Localize_Swift

class SettingsViewController: UITableViewController {

    // Get directory
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

    lazy var backButton: IconButton = {
        let button = IconButton()
        button.image = Icon.cm.arrowBack
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()

    @IBOutlet weak var enterToSend: UISwitch!
    @IBOutlet weak var micInput: UISwitch!
    @IBOutlet weak var hotwordDetection: UISwitch!
    @IBOutlet weak var speechOutput: UISwitch!
    @IBOutlet weak var speechOutputAlwaysOn: UISwitch!
    @IBOutlet weak var speechRate: UISlider!
    @IBOutlet weak var speechPitch: UISlider!
    // TableView string content
    @IBOutlet weak var enterToSendTitle: UILabel!
    @IBOutlet weak var enterToSendSubtitle: UILabel!
    @IBOutlet weak var micInputTitle: UILabel!
    @IBOutlet weak var micInputSubtitle: UILabel!
    @IBOutlet weak var hotwordDirectionTitle: UILabel!
    @IBOutlet weak var hotwordDirectionSubtitle: UILabel!
    @IBOutlet weak var speechOutputTitle: UILabel!
    @IBOutlet weak var speechOutputSubtitle: UILabel!
    @IBOutlet weak var speechOutputAlwaysTitle: UILabel!
    @IBOutlet weak var speechOutputAlwaysSubtitle: UILabel!
    @IBOutlet weak var languageTitle: UILabel!
    @IBOutlet weak var languageSubtitle: UILabel!
    @IBOutlet weak var speechRateTitle: UILabel!
    @IBOutlet weak var speechPitchTitle: UILabel!
    @IBOutlet weak var retrainVModelTitle: UILabel!
    @IBOutlet weak var deleteVModelTitle: UILabel!
    @IBOutlet weak var rateSusiTitle: UILabel!
    @IBOutlet weak var rateSusiSubtitle: UILabel!
    @IBOutlet weak var shareSusiTitle: UILabel!
    @IBOutlet weak var shareSusiSubtitle: UILabel!
    @IBOutlet weak var resetPassTitle: UILabel!
    @IBOutlet weak var logoutTitle: UILabel!
    @IBOutlet weak var devicesTitle: UILabel!
    @IBOutlet weak var devicesSubtitle: UILabel!
    @IBOutlet weak var setupDeviceTitle: UILabel!
    @IBOutlet weak var susiVoiceLanguageLabel: UILabel!
    @IBOutlet weak var aboutUsTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignDefaults()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(localizeStrings),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
        localizeStrings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTitle()
        setupTheme()
        setLanguageLabel()
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            switch section {
            case 0:
                header.textLabel?.text = ControllerConstants.Settings.chatSettings.localized()
            case 1:
                header.textLabel?.text = ControllerConstants.Settings.micSettings.localized()
            case 2:
                header.textLabel?.text = ControllerConstants.Settings.speechSettings.localized()
            case 3:
                header.textLabel?.text = ControllerConstants.Settings.susiVoiceModel.localized()
            case 4:
                header.textLabel?.text = ControllerConstants.Settings.devices.localized()
            case 5:
                header.textLabel?.text = ControllerConstants.Settings.miscellaneous.localized()
            default:
                break
            }
            header.textLabel?.text = header.textLabel?.text?.uppercased()
            header.textLabel?.textColor = UIColor.hexStringToUIColor(hex: "#009688")
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row

        if section == 2 {
            if row == 2 {
                doChangeLanguage()
            }
        } else if section == 3 {
            if row == 0 {
                presentTrainingController()
            } else if row == 1 {
                deleteVoiceModel()
            }
        } else if section == 4 {
            if row == 0 {
                presentDeviceActivity()
            } else if row == 1 {
                presentDeviceInstruction()
            }
        } else if section == 5 {
            if row == 1 {
                shareApp()
            } else if row == 2 {
                presentResetPasswordController()
            } else if row == 3 {
                if logoutTitle.text == ControllerConstants.Settings.logout.localized() {
                    let logoutAlert = UIAlertController(title: ControllerConstants.Logout.title, message: ControllerConstants.Logout.message, preferredStyle: UIAlertController.Style.alert)
                    logoutAlert.addAction(UIAlertAction(title: ControllerConstants.Logout.cancel, style: .default, handler: { (action: UIAlertAction!) in
                        logoutAlert.dismiss(animated: true, completion: nil)
                    }))
                    logoutAlert.addAction(UIAlertAction(title: ControllerConstants.Logout.confirm, style: .destructive, handler: { (action: UIAlertAction!) in
                        self.logoutUser()
                    }))
                    present(logoutAlert, animated: true, completion: nil)
                } else {
                    logoutUser()
                }
           }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = UserDefaults.standard.dictionary(forKey: ControllerConstants.UserDefaultsKeys.user)
        if indexPath.section == 5 && indexPath.row == 2 && user == nil {
            cell.isUserInteractionEnabled = false
            cell.textLabel?.isEnabled = false
            cell.textLabel?.text = ControllerConstants.Settings.resetPass.localized()
            cell.textLabel?.textColor = .lightGray
            cell.selectionStyle = .none
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let user = UserDefaults.standard.dictionary(forKey: ControllerConstants.UserDefaultsKeys.user)
        if indexPath.section == 4 && indexPath.row == 2 && user == nil {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

    @objc func localizeStrings() {
        enterToSendTitle.text = ControllerConstants.Settings.enterToSend.localized()
        enterToSendSubtitle.text = ControllerConstants.Settings.enterToSendSubtitle.localized()
        micInputTitle.text = ControllerConstants.Settings.micInput.localized()
        micInputSubtitle.text = ControllerConstants.Settings.micInputSubtitle.localized()
        hotwordDirectionTitle.text = ControllerConstants.Settings.hotwordDirection.localized()
        hotwordDirectionSubtitle.text = ControllerConstants.Settings.hotwordDirectionSubtitle.localized()
        speechOutputTitle.text = ControllerConstants.Settings.speechOutput.localized()
        speechOutputSubtitle.text = ControllerConstants.Settings.speechOutputSubtitle.localized()
        speechOutputAlwaysTitle.text = ControllerConstants.Settings.speechOutputAlways.localized()
        speechOutputAlwaysSubtitle.text = ControllerConstants.Settings.speechOutputAlwaysSubtitle.localized()
        languageTitle.text = ControllerConstants.Settings.language.localized()
        languageSubtitle.text = ControllerConstants.Settings.languageSubtitle.localized()
        speechRateTitle.text = ControllerConstants.Settings.speechRate.localized()
        speechPitchTitle.text = ControllerConstants.Settings.speechPitch.localized()
        retrainVModelTitle.text = ControllerConstants.Settings.retrainVModel.localized()
        deleteVModelTitle.text = ControllerConstants.Settings.deleteVModel.localized()
        rateSusiTitle.text = ControllerConstants.Settings.rateSusi.localized()
        rateSusiSubtitle.text = ControllerConstants.Settings.rateSusiSubtitle.localized()
        shareSusiTitle.text = ControllerConstants.Settings.shareSusi.localized()
        shareSusiSubtitle.text = ControllerConstants.Settings.shareSusiSubtitle.localized()
        resetPassTitle.text = ControllerConstants.Settings.resetPass.localized()
        logoutTitle.text = ControllerConstants.Settings.logout.localized()
        aboutUsTitle.text = ControllerConstants.Settings.about.localized()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            logoutTitle.text = (appDelegate.currentUser != nil) ? ControllerConstants.Settings.logout.localized() : ControllerConstants.Settings.login.localized()
        }
        tableView.reloadData()
    }
}
