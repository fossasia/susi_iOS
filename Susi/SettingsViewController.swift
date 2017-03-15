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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionHeaders.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return 4
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCell
        
        if indexPath.section == 0 {
            cell.titleLabel.text = "Enter To Send"
            cell.detailLabel.text = "Send message by hitting return"
            cell.settingSwitch.isHidden = false
        } else if indexPath.section == 1 {
            cell.titleLabel.text = "Mic Input"
            cell.detailLabel.text = "Send message by hitting return"
            cell.settingSwitch.isHidden = false
        } else {
            if indexPath.item == 0 {
                cell.titleLabel.text = "Speech Output"
                cell.detailLabel.text = "Enable speech output only for input"
                cell.settingSwitch.isHidden = false
            } else if indexPath.item == 1 {
                cell.titleLabel.text = "Speech Output Always On"
                cell.detailLabel.text = "Enable speech output regardless of input"
                cell.settingSwitch.isHidden = false
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
        
        return cell
    }
    
    // Set frame for cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 44)
    }
    
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

}
