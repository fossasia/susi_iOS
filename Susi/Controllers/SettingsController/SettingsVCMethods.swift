//
//  SettingsVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-07-29.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import RealmSwift
import Material

extension SettingsViewController {

    func setupView() {
        view.backgroundColor = .white
    }

    // Setup Navigation Bar
    func setupTitle() {
        navigationItem.title = ControllerConstants.Settings.settings
        navigationItem.titleLabel.textAlignment = .left
        navigationItem.titleLabel.textColor = .white
        navigationItem.leftViews = [backButton]
    }

    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    func setupTheme() {
        guard let navBar = navigationController?.navigationBar as? NavigationBar else {
            return
        }
        navigationItem.titleLabel.textColor = .white

        let activeTheme = UserDefaults.standard.string(forKey: ControllerConstants.UserDefaultsKeys.theme)
        if activeTheme == theme.light.rawValue {
            navBar.backgroundColor = UIColor.hexStringToUIColor(hex: "#4184F3")
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.hexStringToUIColor(hex: "#4184F3")
        } else if activeTheme == theme.dark.rawValue {
            navBar.backgroundColor = UIColor.defaultColor()
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.defaultColor()
        }
    }

    // Setup Collection View
    func setupCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.delegate = self

        collectionView?.register(SettingsHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(SettingsCell.self, forCellWithReuseIdentifier: ControllerConstants.cellId)
    }

    func logoutUser() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }

        Client.sharedInstance.logoutUser { (success, error) in
            DispatchQueue.main.async {
                if success {
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                } else {
                    debugPrint(error)
                }
            }
        }
    }

    func themeToggleAlert() {
        let imageDialog = UIAlertController(title: ControllerConstants.toggleTheme, message: nil, preferredStyle: UIAlertControllerStyle.alert)

        imageDialog.addAction(UIAlertAction(title: theme.dark.rawValue.capitalized, style: .default, handler: { (_: UIAlertAction!) in
            imageDialog.dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(theme.dark.rawValue, forKey: ControllerConstants.UserDefaultsKeys.theme)
            self.settingChanged(sender: self.imagePicker)
            self.setupTheme()
        }))

        imageDialog.addAction(UIAlertAction(title: theme.light.rawValue.capitalized, style: .default, handler: { (_: UIAlertAction!) in
            imageDialog.dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(theme.light.rawValue, forKey: ControllerConstants.UserDefaultsKeys.theme)
            self.settingChanged(sender: self.imagePicker)
            self.setupTheme()
        }))

        imageDialog.addAction(UIAlertAction(title: ControllerConstants.dialogCancelAction, style: .cancel, handler: { (_: UIAlertAction!) in
            imageDialog.dismiss(animated: true, completion: nil)
        }))

        self.present(imageDialog, animated: true, completion: nil)
    }

    func settingChanged(sender: AnyObject?) {

        var params = [String: AnyObject]()

        if let userData = UserDefaults.standard.dictionary(forKey: ControllerConstants.UserDefaultsKeys.user) as [String : AnyObject]? {
            let user = User(dictionary: userData)
            params[Client.UserKeys.AccessToken] = user.accessToken as AnyObject
        }

        var key: String = ""

        if let senderTag = sender?.tag {
            if senderTag == 0 {
                key = ControllerConstants.UserDefaultsKeys.enterToSend
                UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: key), forKey: key)
                params[ControllerConstants.key] = key as AnyObject
                params[ControllerConstants.value] = UserDefaults.standard.bool(forKey: key) as AnyObject
            } else if senderTag == 1 {
                key = ControllerConstants.UserDefaultsKeys.micInput
                UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: key), forKey: key)
                params[ControllerConstants.key] = key as AnyObject
                params[ControllerConstants.value] = UserDefaults.standard.bool(forKey: key) as AnyObject
            } else if senderTag == 2 {
                key = ControllerConstants.UserDefaultsKeys.hotwordEnabled
                UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: key), forKey: key)
                params[ControllerConstants.key] = key as AnyObject
                params[ControllerConstants.value] = UserDefaults.standard.bool(forKey: key) as AnyObject
            } else if senderTag == 3 {
                key = ControllerConstants.UserDefaultsKeys.speechOutput
                UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: key), forKey: key)
                params[ControllerConstants.key] = key as AnyObject
                params[ControllerConstants.value] = UserDefaults.standard.bool(forKey: key) as AnyObject
            } else if senderTag == 4 {
                key = ControllerConstants.UserDefaultsKeys.speechOutputAlwaysOn
                UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: key), forKey: key)
                params[ControllerConstants.key] = key as AnyObject
                params[ControllerConstants.value] = UserDefaults.standard.bool(forKey: key) as AnyObject
            }
        } else {
            key = ControllerConstants.UserDefaultsKeys.theme
            params[ControllerConstants.key] = key as AnyObject
            params[ControllerConstants.value] = UserDefaults.standard.string(forKey: key) as AnyObject
        }

        Client.sharedInstance.changeUserSettings(params) { (_, message) in
            DispatchQueue.main.async {
                self.view.makeToast(message)
            }
        }
    }

}
