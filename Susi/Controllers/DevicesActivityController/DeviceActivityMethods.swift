//
//  DeviceActivityMethods.swift
//  Susi
//
//  Created by JOGENDRA on 25/06/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import SystemConfiguration.CaptiveNetwork
import UIKit

extension DevicesActivityViewController {

    // Setup Navigation Bar
    func setupTitle() {
        navigationItem.titleLabel.text = ControllerConstants.devices.localized()
        navigationItem.titleLabel.textAlignment = .left
        navigationItem.titleLabel.textColor = .white
        navigationItem.leftViews = [backButton]
        navigationItem.rightViews = [addDeviceButton]
        if let navbar = navigationController?.navigationBar {
            navbar.barTintColor = UIColor.defaultColor()
        }
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func presentInstructionController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let deviceInstructionsViewController = storyboard.instantiateViewController(withIdentifier: "DeviceInstructionsViewController")
        let nvc = AppNavigationController(rootViewController: deviceInstructionsViewController)
        present(nvc, animated: true, completion: nil)
    }

    func fetchSSIDInfo() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as? [String] {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }

    // MARK: - Smart Speaker UI Flow

    func presentRoomsPicker() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let roomVC = storyboard.instantiateViewController(withIdentifier: "RoomPickerVC") as? RoomPickerController {
            roomVC.deviceActivityVC = self
            let roomNVC = AppNavigationController(rootViewController: roomVC)
            self.present(roomNVC, animated: true)
        }
    }

    func presentRoomsPopup() {
        roomAlertController = UIAlertController(title: ControllerConstants.DeviceActivity.roomAlertTitle, message: ControllerConstants.DeviceActivity.roomAlertMessage, preferredStyle: .alert)
        roomAlertController.addTextField(configurationHandler: { (textfield: UITextField) in
            textfield.placeholder = ControllerConstants.DeviceActivity.enterRoomPlaceholder
            textfield.borderStyle = .roundedRect
        })
        let nextAction = UIAlertAction(title: "Next", style: .default, handler: { _ -> Void in
            let roomNameTextField = self.roomAlertController.textFields![0] as UITextField
            if let roomName = roomNameTextField.text {
                self.setDeviceRoom(for: roomName)
            }
        })
        let chooseRoomAction = UIAlertAction(title: "Choose Room", style: .default, handler: { _ -> Void in
            self.presentRoomsPicker()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_: UIAlertAction) -> Void in
        })
        roomAlertController.addAction(cancelAction)
        roomAlertController.addAction(nextAction)
        roomAlertController.addAction(chooseRoomAction)

        self.present(roomAlertController, animated: true, completion: nil)
        removeTextBorder(for: roomAlertController)
    }

    func presentSelectedRoomPopup() {
        roomAlertController = UIAlertController(title: ControllerConstants.DeviceActivity.roomAlertTitle, message: ControllerConstants.DeviceActivity.roomAlertMessage, preferredStyle: .alert)
        roomAlertController.addTextField(configurationHandler: { (textfield: UITextField) in
            textfield.text = UserDefaults.standard.value(forKey: ControllerConstants.UserDefaultsKeys.room) as? String
            textfield.borderStyle = .roundedRect
        })
        let nextAction = UIAlertAction(title: "Next", style: .default, handler: { _ -> Void in
            let roomNameTextField = self.roomAlertController.textFields![0] as UITextField
            if let roomName = roomNameTextField.text {
                self.setDeviceRoom(for: roomName)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_: UIAlertAction) -> Void in
        })
        roomAlertController.addAction(cancelAction)
        roomAlertController.addAction(nextAction)

        self.present(roomAlertController, animated: true, completion: nil)
        removeTextBorder(for: roomAlertController)
    }

    func setDeviceRoom(for room: String) {
        self.roomAlertController.dismiss(animated: true, completion: nil)
        self.loadAlertIndicator(with: "Adding Room..")

        let params = [
            Client.SmartSpeaker.roomName: room as AnyObject
        ]

        Client.sharedInstance.speakerConfiguration(params) { (success, message) in
            DispatchQueue.main.async {
                self.alertController.dismiss(animated: true, completion: nil)
                if success {
                    self.presentWifiCredentialsPopup()
                } else {
                    self.view.makeToast("", point: self.view.center, title: message, image: nil, completion: { _ in
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.presentRoomsPopup()
                    })
                }
            }
        }
    }

    func presentWifiCredentialsPopup() {
        wifiAlertController = UIAlertController(title: ControllerConstants.DeviceActivity.wifiAlertTitle, message: ControllerConstants.DeviceActivity.wifiAlertMessage, preferredStyle: .alert)
        wifiAlertController.addTextField(configurationHandler: { (textfield: UITextField) in
            textfield.placeholder = ControllerConstants.DeviceActivity.wifiPasswordPlaceholder
            textfield.borderStyle = .roundedRect
            textfield.isSecureTextEntry = true
        })
        let nextAction = UIAlertAction(title: "Next", style: .default, handler: { _ -> Void in
            let passwordTextField = self.wifiAlertController.textFields![0] as UITextField
            if let password = passwordTextField.text {
                self.sendWifiCredentials(for: password)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_: UIAlertAction) -> Void in
        })
        wifiAlertController.addAction(cancelAction)
        wifiAlertController.addAction(nextAction)

        self.present(wifiAlertController, animated: true, completion: nil)
        removeTextBorder(for: wifiAlertController)
    }

    func sendWifiCredentials(for password: String) {
        self.wifiAlertController.dismiss(animated: true, completion: nil)
        self.loadAlertIndicator(with: "Sharing credentials..")

        guard let SSID = fetchSSIDInfo() else {
            self.view.makeToast("Device is not connected to SUSI.AI Wi-Fi")
            return
        }
        let params = [
            Client.SmartSpeaker.wifiSSID: SSID as AnyObject,
            Client.SmartSpeaker.wifiPassword: password as AnyObject
        ]

        Client.sharedInstance.sendWifiCredentials(params) { (success, message) in
            DispatchQueue.main.async {
                self.alertController.dismiss(animated: true, completion: nil)
                if success {
                    self.presentUserPasswordPopup()
                } else {
                    self.view.makeToast("", point: self.view.center, title: message, image: nil, completion: { _ in
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.presentWifiCredentialsPopup()
                    })
                }
            }
        }
    }

    func presentUserPasswordPopup() {
        passwordAlertController = UIAlertController(title: ControllerConstants.DeviceActivity.passwordAlertTitle,
                                                    message: ControllerConstants.DeviceActivity.passwordAlertMessage,
                                                    preferredStyle: .alert)
        passwordAlertController.addTextField(configurationHandler: { (textfield: UITextField) in
            textfield.placeholder = ControllerConstants.DeviceActivity.userPasswordPlaceholder
            textfield.borderStyle = .roundedRect
            textfield.isSecureTextEntry = true
        })
        let nextAction = UIAlertAction(title: "Next", style: .default, handler: { _ -> Void in
            let passwordTextField = self.passwordAlertController.textFields![0] as UITextField
            if let password = passwordTextField.text {
                self.sendAuthCredentials(userPassword: password)
            }
        })
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_: UIAlertAction) -> Void in
        })
        passwordAlertController.addAction(cancleAction)
        passwordAlertController.addAction(nextAction)
        self.present(passwordAlertController, animated: true, completion: nil)
        removeTextBorder(for: passwordAlertController)
    }

    func sendAuthCredentials(userPassword: String) {
        self.passwordAlertController.dismiss(animated: true, completion: nil)
        self.loadAlertIndicator(with: "Authorizing..")

        let choice: String = "y"
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let currentuser = appDelegate.currentUser {
            let userEmail = currentuser.emailID

            let params = [
                Client.SmartSpeaker.auth: choice as AnyObject,
                Client.SmartSpeaker.email: userEmail as AnyObject,
                Client.SmartSpeaker.password: userPassword as AnyObject
            ]

            Client.sharedInstance.sendAuthCredentials(params) { (success, message) in
                DispatchQueue.main.async {
                    self.alertController.dismiss(animated: true, completion: nil)
                    if success {
                        self.setConfiguration()
                    } else {
                        self.view.makeToast("", point: self.view.center, title: message, image: nil, completion: { _ in
                            UIApplication.shared.endIgnoringInteractionEvents()
                            self.presentUserPasswordPopup()
                        })
                    }
                }
            }
        }
    }

    func setConfiguration() {
        self.passwordAlertController.dismiss(animated: true, completion: nil)

        let defaultSTT = "google"
        let defaultTTS = "google"
        let defaultHotword = "y"
        let defaultWake = "n"

        let params = [
            Client.SmartSpeaker.STT: defaultSTT as AnyObject,
            Client.SmartSpeaker.TTS: defaultTTS as AnyObject,
            Client.SmartSpeaker.hotword: defaultHotword as AnyObject,
            Client.SmartSpeaker.wake: defaultWake as AnyObject
        ]

        Client.sharedInstance.setConfiguration(params) { (success, message) in
            DispatchQueue.main.async {
                if success {
                    // Successfully Configured
                    self.isSetupDone = true
                    self.view.makeToast(ControllerConstants.DeviceActivity.doneSetupDetailText)
                } else {
                    self.view.makeToast("", point: self.view.center, title: message, image: nil, completion: { _ in
                        UIApplication.shared.endIgnoringInteractionEvents()
                    })
                }
            }
        }
    }

    func removeTextBorder(for alterController: UIAlertController) {
        for textfield: UIView in alterController.textFields! {
            let container: UIView? = textfield.superview
            let effectView = container?.superview?.subviews[0]
            if effectView != nil {
                container?.backgroundColor = UIColor.clear
                effectView?.removeFromSuperview()
            }
        }
    }

    func loadAlertIndicator(with message: String) {
        alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.black

        let attributedString = NSAttributedString(string: message, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.iOSGray()])
        alertController.setValue(attributedString, forKey: "attributedMessage")

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 8, y: 2, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.color = UIColor.iOSGray()
        loadingIndicator.startAnimating()
        alertController.view.addSubview(loadingIndicator)

        self.present(alertController, animated: true, completion: nil)
    }

}
