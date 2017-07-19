//
//  TextViewDelegate.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-07-19.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

extension ChatViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.sendButton.tag = 0
            self.sendButton.setImage(UIImage(named: ControllerConstants.mic), for: .normal)
        } else {
            self.sendButton.tag = 1
            self.sendButton.setImage(UIImage(named: ControllerConstants.send), for: .normal)
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" && UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.enterToSend) {
            handleSend()
            return false
        }
        return true
    }

}
