//
//  ChatMessageCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-21.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

class ChatMessageCell: BaseCell, UITextViewDelegate {

    lazy var messageTextView: LongPressToCopyTextView = {
        let textView = LongPressToCopyTextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = ControllerConstants.defaultMessage.localized()
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.isSelectable = false
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.addLongPressGesture()
        return textView
    }()

    let textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 8)
        label.textColor = .black
        return label
    }()

    override func setupViews() {
        super.setupViews()
        self.contentView.addSubview(textBubbleView)
        self.contentView.addSubview(messageTextView)
        accessibilityIdentifier = ControllerConstants.TestKeys.chatCells

        backgroundColor = .clear
    }

    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange) -> Bool {
        return true
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }

}
