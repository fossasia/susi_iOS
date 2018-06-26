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

}
