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
        navigationItem.titleLabel.text = ControllerConstants.settings.localized()
        navigationItem.titleLabel.textAlignment = .left
        navigationItem.titleLabel.textColor = .white
        navigationItem.leftViews = [backButton]
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    func setupTheme() {
        navigationItem.titleLabel.textColor = .white
        if let navbar = navigationController?.navigationBar {
            navbar.barTintColor = UIColor.defaultColor()
        }
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.defaultColor()
    }

    func setLanguageLabel() {
        let languageName = UserDefaults.standard.object(forKey: ControllerConstants.UserDefaultsKeys.languageName) as? String
        let languageCode = UserDefaults.standard.object(forKey: ControllerConstants.UserDefaultsKeys.languageCode) as? String
        if languageName != nil && languageCode != nil {
            susiVoiceLanguageLabel.text = "\(languageName!) (\(languageCode!))"
        } else {
            susiVoiceLanguageLabel.text = "English (en-US)"
        }
    }

    func logoutUser() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        deleteVoiceModel()

        Client.sharedInstance.logoutUser { (success, error) in
            DispatchQueue.main.async {
                if success {
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.currentUser = nil
                        self.presentLoginScreen()
                    }
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
            } else if senderTag == 5 {
                key = ControllerConstants.UserDefaultsKeys.speechRate
            } else if senderTag == 6 {
                key = ControllerConstants.UserDefaultsKeys.speechPitch
            }

            if let slider = sender as? UISlider {
                UserDefaults.standard.set(slider.value, forKey: key)
                params[key] = UserDefaults.standard.value(forKey: key) as AnyObject
            } else {
                UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: key), forKey: key)
                params[key] = UserDefaults.standard.bool(forKey: key) as AnyObject
            }

            if let delegate = UIApplication.shared.delegate as? AppDelegate, let user = delegate.currentUser {
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
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "TrainingViewController")
        let nvc = AppNavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }

    func presentResetPasswordController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ResetPasswordController")
        let nvc = AppNavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }

    func presentDeviceActivity() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate, delegate.currentUser != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let devicesActivityController = storyboard.instantiateViewController(withIdentifier: "DevicesActivityController")
            let nvc = AppNavigationController(rootViewController: devicesActivityController)
            present(nvc, animated: true, completion: nil)
        } else {
            presentLoginAlert()
        }
    }

    func presentLoginAlert() {
        let loginAlertController = UIAlertController(title: "You are not logged-in", message: "Please login to connect device", preferredStyle: .alert)
        let loginAction = UIAlertAction(title: "Login", style: .default, handler: { _ in
            self.presentLoginScreen()
        })
        let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        loginAlertController.addAction(cancleAction)
        loginAlertController.addAction(loginAction)
        self.present(loginAlertController, animated: true, completion: nil)
    }

    func presentDeviceInstruction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let deviceInstructionsViewController = storyboard.instantiateViewController(withIdentifier: "DeviceInstructionsViewController")
        let nvc = AppNavigationController(rootViewController: deviceInstructionsViewController)
        present(nvc, animated: true, completion: nil)
    }

    func presentLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginController")
        present(loginVC, animated: true, completion: nil)
    }

    func doChangeLanguage() {
        let languages = Localize.availableLanguages().compactMap { Localize.displayNameForLanguage($0).isEmpty ? nil : $0 }
        let actionSheet = UIAlertController(title: nil, message: "Set a language".localized(), preferredStyle: UIAlertController.Style.actionSheet)
        for language in languages {
            let displayName = Localize.displayNameForLanguage(language)
            let languageAction = UIAlertAction(title: displayName.capitalized, style: .default, handler: {
                (_: UIAlertAction!) -> Void in
                Localize.setCurrentLanguage(language)
            })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: ControllerConstants.dialogCancelAction.localized(),
                                         style: UIAlertAction.Style.cancel,
                                         handler: {
                                            (_: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
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
        self.view.makeToast("Model deleted successfully".localized())
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

    func assignDefaults() {
        enterToSend.isOn = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.enterToSend)
        micInput.isOn = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.micInput)
        hotwordDetection.isOn = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.hotwordEnabled)
        speechOutput.isOn = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.speechOutput)
        speechOutputAlwaysOn.isOn = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.speechOutputAlwaysOn)
        speechRate.value = UserDefaults.standard.float(forKey: ControllerConstants.UserDefaultsKeys.speechRate)
        speechPitch.value = UserDefaults.standard.float(forKey: ControllerConstants.UserDefaultsKeys.speechPitch)
    }

    func shareApp() {
        // Set the default sharing message.
        let message = ControllerConstants.meetSusi.localized()
        // Set the link to share.
        if let link = NSURL(string: "http://susi.ai") {
            let objectsToShare = [message, link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func roundedCorner() {
        userImage.layer.cornerRadius = 25.0
        userImage.layer.borderWidth = 1.0
        userImage.layer.borderColor = UIColor.iOSGray().cgColor
        userImage.layer.masksToBounds = true
        userImage.clipsToBounds = true
    }
    
    static func getAvatarPath(_ accessToken: String) -> String {
        return "\(Client.APIURLs.SusiAPI)\(Client.Methods.GetUserAvatar)?access_token=\(accessToken)"
    }
    
}
