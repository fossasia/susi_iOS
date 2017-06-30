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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTitle()
        setupCollectionView()
    }

    // Setup Navigation Bar
    func setupTitle() {
        navigationItem.title = ControllerConstants.Settings.settings
        navigationItem.titleLabel.textAlignment = .left
        navigationItem.titleLabel.textColor = .white
    }

    // Setup View
    func setupView() {
        self.view.backgroundColor = .white
    }

    // Setup Collection View
    func setupCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.delegate = self

        collectionView?.register(SettingsHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(SettingsCell.self, forCellWithReuseIdentifier: ControllerConstants.cellId)
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
        } else {
            return 4
        }
    }

    // Configures cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConstants.cellId, for: indexPath) as! SettingsCell

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
        } else {
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
            } else if indexPath.item == 2 {
                cell.titleLabel.text = ControllerConstants.Settings.language
                cell.detailLabel.text = ControllerConstants.Settings.selectLanguage
                cell.settingSwitch.removeFromSuperview()
            } else {
                cell.titleLabel.text = ControllerConstants.Settings.rateSusi
                cell.detailLabel.text = ControllerConstants.Settings.rateOnAppStore
                cell.settingSwitch.removeFromSuperview()
            }
        }

        cell.settingSwitch.addTarget(self, action: #selector(switchDidToggle(sender:)), for: .valueChanged)

        return cell
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

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SettingsHeaderView

        switch kind {
        case UICollectionElementKindSectionHeader:

            headerView.settingsLabel.text = sectionHeaders[indexPath.section]
            return headerView

        default:
            return UICollectionReusableView()
        }

    }

    func switchDidToggle(sender: UISwitch!) {
        if sender.tag == 0 {
            UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.enterToSend), forKey: ControllerConstants.UserDefaultsKeys.enterToSend)
        } else if sender.tag == 1 {
            UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.micInput), forKey: ControllerConstants.UserDefaultsKeys.micInput)
        } else if sender.tag == 2 {
            UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.hotwordEnabled), forKey: ControllerConstants.UserDefaultsKeys.hotwordEnabled)
        } else if sender.tag == 3 {
            UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.speechOutput), forKey: ControllerConstants.UserDefaultsKeys.speechOutput)
        } else if sender.tag == 4 {
            UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.speechOutputAlwaysOn), forKey: ControllerConstants.UserDefaultsKeys.speechOutputAlwaysOn)
        }
    }

}
