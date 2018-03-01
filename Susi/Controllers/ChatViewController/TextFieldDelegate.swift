//
//  TextFieldDelegate.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-07-19.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

extension ChatViewController: UITextFieldDelegate {

    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = inputTextField.text, text.isEmpty {
            sendButton.tag = 0
            sendButton.setImage(ControllerConstants.Images.microphone, for: .normal)
            sendButton.tintColor = UIColor.defaultColor()
            sendButton.backgroundColor = .clear
        } else {
            sendButton.tag = 1
            sendButton.setImage(ControllerConstants.Images.send, for: .normal)
            sendButton.tintColor = .white
            sendButton.backgroundColor = UIColor.defaultColor()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.enterToSend) {
            handleSend()
            return false
        }
        return true
    }

}
