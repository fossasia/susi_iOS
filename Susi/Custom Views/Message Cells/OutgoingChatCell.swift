//
//  OutgoingChatCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import SwiftDate

class OutgoingChatCell: ChatMessageCell {

    var message: Message? {
        didSet {
            messageTextView.text = message?.message
        }
    }

    override func setupViews() {
        super.setupViews()
    }

    func setupDate() {
        let date = DateInRegion(absoluteDate: message?.queryDate as Date!)
        let str = date.string(format: .custom("h:mm a"))
        timeLabel.text = str
        textBubbleView.addSubview(timeLabel)
        textBubbleView.addConstraintsWithFormat(format: "H:[v0]-8-|", views: timeLabel)
        textBubbleView.addConstraintsWithFormat(format: "V:[v0]-4-|", views: timeLabel)
    }

    func setupCell(_ estimatedFrame: CGRect, _ viewFrame: CGRect) {
        messageTextView.frame = CGRect(x: viewFrame.width - max(estimatedFrame.width + 34, viewFrame.width / 4), y: -2, width: max(estimatedFrame.width + 16, viewFrame.width / 4 - 16), height: estimatedFrame.height + 20)
        textBubbleView.frame = CGRect(x: viewFrame.width - max(estimatedFrame.width + 40, viewFrame.width / 4 + 8), y: -4, width: max(estimatedFrame.width + 34, viewFrame.width / 4), height: estimatedFrame.height + 26)

        setupDate()
        setupTheme()
    }

    func setupTheme() {
        let activeTheme = UserDefaults.standard.string(forKey: ControllerConstants.UserDefaultsKeys.theme)
        if activeTheme == theme.light.rawValue {
            textBubbleView.backgroundColor = UIColor.hexStringToUIColor(hex: "#E0E0E0")
            messageTextView.textColor = .black
        } else if activeTheme == theme.dark.rawValue {
            textBubbleView.backgroundColor = UIColor.incomingMessageTintColor()
            messageTextView.textColor = .black
        }
    }

}
