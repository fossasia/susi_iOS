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
import Toast_Swift
import Localize_Swift

extension SettingsViewController {
    
    // Setup Navigation Bar
    func setupTitle() {
        navigationItem.title = ControllerConstants.settings
        navigationItem.titleLabel.textAlignment = .left
        navigationItem.titleLabel.textColor = .white
        navigationItem.leftViews = [backButton]
    }

    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Language chageing
    func changeLanguage() {
        actionSheet = UIAlertController(title: nil, message: "Change Language", preferredStyle: UIAlertControllerStyle.actionSheet)
        for language in availableLanguages {
            let displayName = Localize.displayNameForLanguage(language)
            let languageAction = UIAlertAction(title: displayName, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                Localize.setCurrentLanguage(language)
            })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }

    func setupTheme() {
        navigationItem.titleLabel.textColor = .white
        if let navbar = navigationController?.navigationBar {
            navbar.barTintColor = UIColor.hexStringToUIColor(hex: "#4184F3")
        }
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.hexStringToUIColor(hex: "#4184F3")
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

    @IBAction func settingChanged(sender: AnyObject?) {
        var params = [String: AnyObject]()
        var key: String = ""

        if let senderTag = sender?.tag {
            if senderTag == 0 {
                key = ControllerConstants.UserDefaultsKeys.enterToSend
            } else if senderTag == 1 {
                key = ControllerConstants.UserDefaultsKeys.micInput
            } else if senderTag == 2 {
                key = ControllerConstants.UserDefaultsKeys.hotwordEnabled
            } else if senderTag == 3 {
                key = ControllerConstants.UserDefaultsKeys.speechOutput
            } else if senderTag == 4 {
                key = ControllerConstants.UserDefaultsKeys.speechOutputAlwaysOn
            }
            UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: key), forKey: key)
            params[ControllerConstants.key] = key as AnyObject
            params[ControllerConstants.value] = UserDefaults.standard.bool(forKey: key) as AnyObject

            if let userData = UserDefaults.standard.dictionary(forKey: ControllerConstants.UserDefaultsKeys.user) as [String : AnyObject]? {
                let user = User(dictionary: userData)
                params[Client.UserKeys.AccessToken] = user.accessToken as AnyObject
                params[ControllerConstants.count] = 1 as AnyObject

                Client.sharedInstance.changeUserSettings(params) { (_, message) in
                    DispatchQueue.main.async {
                        self.view.makeToast(message)
                    }
                }
            }
        }
    }

    func presentTrainingController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "trainingViewController")
        let nvc = AppNavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }

    func presentResetPasswordController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ResetPasswordController")
        let nvc = AppNavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }

    func deleteVoiceModel() {
        do {
            if let file1 = checkIfFileExistsAndReturnPath(fileIdentifier: 0) {
                try FileManager.default.removeItem(at: file1)
            }
            if let file2 = checkIfFileExistsAndReturnPath(fileIdentifier: 1) {
                try FileManager.default.removeItem(at: file2)
            }
            if let file3 = checkIfFileExistsAndReturnPath(fileIdentifier: 2) {
                try FileManager.default.removeItem(at: file3)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        self.view.makeToast("Model deleted successfully")
    }

    func checkIfFileExistsAndReturnPath(fileIdentifier: Int) -> URL? {
        let recordingName = "recordedVoice\(fileIdentifier).wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        if let path = filePath?.path {
            if FileManager.default.fileExists(atPath: path) {
                return filePath
            }
        }
        return nil
    }

}
