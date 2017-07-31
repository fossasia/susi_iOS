//
//  SettingsViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-15.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class SettingsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let headerId = ControllerConstants.Settings.headerId
    let sectionHeaders = ControllerConstants.Settings.sectionHeaders

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

        setupView()
        setupTitle()
        setupCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTheme()
    }

    // Handles number of sections
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionHeaders.count
    }

    // Handles number of cells for section
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 2
        } else {
            return 5
        }
    }

    // Configures cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConstants.cellId, for: indexPath) as? SettingsCell {
            cell.pulseAnimation = .none
            if indexPath.section == 0 {
                cell.titleLabel.text = ControllerConstants.Settings.enterToSend
                cell.detailLabel.text = ControllerConstants.Settings.sendMessageByReturn
                cell.settingSwitch.tag = 0
                cell.settingSwitch.isOn = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.enterToSend)
            } else if indexPath.section == 1 {
                if indexPath.item == 0 {
                    cell.titleLabel.text = ControllerConstants.Settings.micInput
                    cell.detailLabel.text = ControllerConstants.Settings.sendMessageByReturn
                    cell.settingSwitch.tag = 1
                    cell.settingSwitch.isOn = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.micInput)
                } else if indexPath.item == 1 {
                    cell.titleLabel.text = ControllerConstants.Settings.enableHotword
                    cell.detailLabel.text = ControllerConstants.Settings.susiHotword
                    cell.settingSwitch.tag = 2
                    cell.settingSwitch.isOn = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.hotwordEnabled)
                }
            } else if indexPath.section == 2 {
                if indexPath.item == 0 {
                    cell.titleLabel.text = ControllerConstants.Settings.speechOutput
                    cell.detailLabel.text = ControllerConstants.Settings.enableSpeechOutputOnlyInput
                    cell.settingSwitch.tag = 3
                    cell.settingSwitch.isOn = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.speechOutput)
                } else if indexPath.item == 1 {
                    cell.titleLabel.text = ControllerConstants.Settings.speechOutputAlwaysOn
                    cell.detailLabel.text = ControllerConstants.Settings.enableSpeechOutputOutputRegardlessOfInput
                    cell.settingSwitch.isOn = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.speechOutputAlwaysOn)
                    cell.settingSwitch.tag = 4
                }
            } else {
                if indexPath.item == 0 {
                    cell.titleLabel.text = ControllerConstants.Settings.changeTheme
                    cell.detailLabel.text = ControllerConstants.Settings.changeThemeDesc
                    cell.pulseAnimation = .point
                    cell.settingSwitch.removeFromSuperview()
                } else if indexPath.item == 1 {
                    cell.titleLabel.text = ControllerConstants.Settings.language
                    cell.detailLabel.text = ControllerConstants.Settings.selectLanguage
                    cell.settingSwitch.removeFromSuperview()
                } else if indexPath.item == 2 {
                    cell.titleLabel.text = ControllerConstants.Settings.rateSusi
                    cell.detailLabel.text = ControllerConstants.Settings.rateOnAppStore
                    cell.settingSwitch.removeFromSuperview()
                } else if indexPath.item == 3 {
                    cell.titleLabel.text = ControllerConstants.Settings.changeWallpaper
                    cell.settingSwitch.removeFromSuperview()
                    cell.pulseAnimation = .point
                    cell.detailLabel.frame = .zero
                } else {
                    cell.titleLabel.text = ControllerConstants.Settings.logout
                    cell.settingSwitch.removeFromSuperview()
                    cell.pulseAnimation = .point
                    cell.detailLabel.frame = .zero
                }
            }

            cell.settingSwitch.addTarget(self, action: #selector(settingChanged(sender:)), for: .valueChanged)

            return cell
        }
        return UICollectionViewCell()
    }

    // Set frame for cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }

    // Handles cell spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    // Handles header view frame
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 44)
    }

    // Configures header view
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? SettingsHeaderView {
            switch kind {
            case UICollectionElementKindSectionHeader:

                headerView.settingsLabel.text = sectionHeaders[indexPath.section]
                return headerView

            default:
                return UICollectionReusableView()
            }
        }
        return UICollectionReusableView()
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            if indexPath.item == 0 {
                themeToggleAlert()
            } else if indexPath.item == 3 {
                showWallpaperOptions()
            } else if indexPath.item == 4 {
                logoutUser()
            }
        }
    }

}
