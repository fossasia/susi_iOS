//
//  TextFieldDelegate.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-07-19.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

extension ChatViewController: UITextViewDelegate {

    @objc func textViewDidChange(_ textField: UITextView) {
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

    func textViewDidBeginEditing(_ textView: UITextView) {
        if inputTextField.textColor == UIColor.lightGray {
            inputTextField.text = nil
            inputTextField.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if inputTextField.text.isEmpty {
            inputTextField.text = ControllerConstants.askSusi.localized()
            inputTextField.textColor = UIColor.lightGray
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.enterToSend) {
                handleSend()
                return false
            }
        }
        return true
    }

}
