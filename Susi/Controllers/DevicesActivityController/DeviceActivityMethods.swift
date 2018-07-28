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

    func presentWifiCredentialsPopup() {
        wifiAlertController = UIAlertController(title: ControllerConstants.DeviceActivity.wifiAlertTitle, message: ControllerConstants.DeviceActivity.wifiAlertMessage, preferredStyle: .alert)
        wifiAlertController.addTextField(configurationHandler: { (textfield: UITextField) in
            textfield.placeholder = ControllerConstants.DeviceActivity.wifiSSIDPlaceholder
            textfield.borderStyle = .roundedRect
        })
        wifiAlertController.addTextField(configurationHandler: { (textfield: UITextField) in
            textfield.placeholder = ControllerConstants.DeviceActivity.wifiPasswordPlaceholder
            textfield.borderStyle = .roundedRect
            textfield.isSecureTextEntry = true
        })
        let nextAction = UIAlertAction(title: "Next", style: .default, handler: { alert -> Void in
            let ssidTextField = self.wifiAlertController.textFields![0] as UITextField
            let passwordTextField = self.wifiAlertController.textFields![1] as UITextField
            if let ssid = ssidTextField.text, let password = passwordTextField.text {
                self.sendWifiCredentials(for: ssid, password: password)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action : UIAlertAction) -> Void in
        })
        wifiAlertController.addAction(cancelAction)
        wifiAlertController.addAction(nextAction)

        self.present(wifiAlertController, animated: true, completion: nil)
        removeTextBorder(for: wifiAlertController)
    }

    func sendWifiCredentials(for SSID: String, password: String) {
        self.wifiAlertController.dismiss(animated: true, completion: nil)
        self.loadAlertIndicator(with: "Sending credentials..")

        Client.sharedInstance.sendWifiCredentials(wifiSSID: SSID, wifiPassword: password) { (success, message) in
            DispatchQueue.main.async {
                if success {
                    self.alertController.dismiss(animated: true, completion: nil)
                    self.presentUserPasswordPopup()
                } else {
                    self.alertController.dismiss(animated: true, completion: nil)
                    self.view.makeToast("", point: self.view.center, title: message, image: nil, completion: { didTap in
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.presentWifiCredentialsPopup()
                    })
                }
            }
        }
    }

    func presentUserPasswordPopup() {
        passwordAlertController = UIAlertController(title: ControllerConstants.DeviceActivity.passwordAlertTitle, message: ControllerConstants.DeviceActivity.passwordAlertMessage, preferredStyle: .alert)
        passwordAlertController.addTextField(configurationHandler: { (textfield: UITextField) in
            textfield.placeholder = ControllerConstants.DeviceActivity.userPasswordPlaceholder
            textfield.borderStyle = .roundedRect
            textfield.isSecureTextEntry = true
        })
        let nextAction = UIAlertAction(title: "Next", style: .default, handler: { alert -> Void in
            let passwordTextField = self.passwordAlertController.textFields![0] as UITextField
            if let password = passwordTextField.text {
                self.sendAuthCredentials(userPassword: password)
            }
        })
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action : UIAlertAction) -> Void in
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
            Client.sharedInstance.sendAuthCredentials(choice: choice, email: userEmail, password: userPassword) { (success, message) in
                DispatchQueue.main.async {
                    if success {
                        self.alertController.dismiss(animated: true, completion: nil)
                        self.setConfiguration()
                    } else {
                        self.alertController.dismiss(animated: true, completion: nil)
                        self.view.makeToast("", point: self.view.center, title: message, image: nil, completion: { didTap in
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
        self.loadAlertIndicator(with: "Configuring..")

        Client.sharedInstance.setConfiguration(stt: "google", tts: "google", hotword: "y", wake: "n") { (success, message) in
            DispatchQueue.main.async {
                if success {
                    self.alertController.dismiss(animated: true, completion: nil)
                    print("Success!")
                } else {
                    self.alertController.dismiss(animated: true, completion: nil)
                    self.view.makeToast("", point: self.view.center, title: message, image: nil, completion: { didTap in
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

        let attributedString = NSAttributedString(string: message, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.iOSGray()])
        alertController.setValue(attributedString, forKey: "attributedMessage")

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 8, y: 2, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.color = UIColor.iOSGray()
        loadingIndicator.startAnimating()
        alertController.view.addSubview(loadingIndicator)

        self.present(alertController, animated: true, completion: nil)
    }

}
