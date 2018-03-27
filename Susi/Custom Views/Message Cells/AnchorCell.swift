//
//  AnchorCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import SwiftDate

class AnchorCell: ChatMessageCell {

    var message: Message? {
        didSet {
            addLink()
        }
    }

    override func setupViews() {
        super.setupViews()

        textBubbleView.layer.borderWidth = 0.2
        textBubbleView.backgroundColor = .white
        messageTextView.textColor = .black
        timeLabel.textColor = .black
    }

    func setupCell(_ frame: CGRect) {
        messageTextView.frame = CGRect(x: 12, y: 4, width: frame.width + 30, height: frame.height + 20)
        textBubbleView.frame = CGRect(x: 8, y: 0, width: frame.width + 40, height: frame.height + 36)
        addBottomView()
    }

    func addBottomView() {
        if let answerData = message?.answerDate as Date? {
            let date = DateInRegion(absoluteDate: answerData)
            let dateString = date.string(format: .custom("h:mm a"))
            timeLabel.text = dateString

            textBubbleView.addSubview(timeLabel)
            textBubbleView.addConstraintsWithFormat(format: "H:[v0]-8-|", views: timeLabel)
            textBubbleView.addConstraintsWithFormat(format: "V:[v0]-4-|", views: timeLabel)
        }
    }

    func addLink() {
        if let message = message, let data = message.anchorData {
            let link = NSMutableAttributedString(string: data.text)
            _ = link.setAsLink(textToFind: data.text, linkURL: data.link, text: message.message)
            messageTextView.attributedText = link
        }
    }

}
