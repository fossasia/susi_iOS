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

    let cellId = "cellId"
    let headerId = "headerId"
    let sectionHeaders = ["Chat Settings", "Mic Settings", "Speech Settings"]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTitle()
        setupCollectionView()
    }

    // Setup Navigation Bar
    func setupTitle() {
        navigationItem.title = "Settings"
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
        collectionView?.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
    }

    // Handles number of sections
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionHeaders.count
    }

    // Handles number of cells for section
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return 4
        }
    }

    // Configures cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCell

        if indexPath.section == 0 {
            cell.titleLabel.text = "Enter To Send"
            cell.detailLabel.text = "Send message by hitting return"
            cell.settingSwitch.isHidden = false
            cell.settingSwitch.tag = 0
            cell.settingSwitch.isOn = UserDefaults.standard.bool(forKey: "enterToSend")
        } else if indexPath.section == 1 {
            cell.titleLabel.text = "Mic Input"
            cell.detailLabel.text = "Send message by hitting return"
            cell.settingSwitch.isHidden = false
            cell.settingSwitch.tag = 1
            cell.settingSwitch.isOn = UserDefaults.standard.bool(forKey: "micInput")
        } else {
            if indexPath.item == 0 {
                cell.titleLabel.text = "Speech Output"
                cell.detailLabel.text = "Enable speech output only for input"
                cell.settingSwitch.isHidden = false
                cell.settingSwitch.tag = 2
                cell.settingSwitch.isOn = UserDefaults.standard.bool(forKey: "speechOutput")
            } else if indexPath.item == 1 {
                cell.titleLabel.text = "Speech Output Always On"
                cell.detailLabel.text = "Enable speech output regardless of input"
                cell.settingSwitch.isHidden = false
                cell.settingSwitch.isOn = UserDefaults.standard.bool(forKey: "speechOutputAlwaysOn")
                cell.settingSwitch.tag = 3
            } else if indexPath.item == 2 {
                cell.titleLabel.text = "Language"
                cell.detailLabel.text = "Select Language"
                cell.settingSwitch.isHidden = true
            } else {
                cell.titleLabel.text = "Rate Susi"
                cell.detailLabel.text = "Rate our app on App Store"
                cell.settingSwitch.isHidden = true
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
            UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "enterToSend"), forKey: "enterToSend")
        } else if sender.tag == 1 {
            UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "micInput"), forKey: "micInput")
        } else if sender.tag == 2 {
            UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "speechOutput"), forKey: "speechOutput")
        } else if sender.tag == 3 {
            UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "speechOutputAlwaysOn"), forKey: "speechOutputAlwaysOn")
        }
    }

}
