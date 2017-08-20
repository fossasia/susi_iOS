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

    func setupTheme() {
        navigationItem.titleLabel.textColor = .white
        if let navbar = navigationController?.navigationBar {
            navbar.barTintColor = UIColor.defaultColor()
        }
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.defaultColor()
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
            } else if senderTag == 5 {
                key = ControllerConstants.UserDefaultsKeys.speechRate
            } else if senderTag == 6 {
                key = ControllerConstants.UserDefaultsKeys.speechPitch
            }

            if let slider = sender as? UISlider {
                UserDefaults.standard.set(slider.value, forKey: key)
            } else {
                UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: key), forKey: key)
            }

            params[ControllerConstants.key] = key as AnyObject
            params[ControllerConstants.value] = UserDefaults.standard.bool(forKey: key) as AnyObject

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
        let vc = ControllerConstants.Controllers.trainingViewController
        let nvc = AppNavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }

    func presentResetPasswordController() {
        let vc = ControllerConstants.Controllers.resetPasswordViewController
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

    func assignDefaults() {
        enterToSend.isOn = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.enterToSend)
        micInput.isOn = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.micInput)
        hotwordDetection.isOn = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.hotwordEnabled)
        speechOutput.isOn = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.speechOutput)
        speechOutputAlwaysOn.isOn = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.speechOutputAlwaysOn)
        speechRate.value = UserDefaults.standard.float(forKey: ControllerConstants.UserDefaultsKeys.speechRate)
        speechPitch.value = UserDefaults.standard.float(forKey: ControllerConstants.UserDefaultsKeys.speechPitch)
    }

}
