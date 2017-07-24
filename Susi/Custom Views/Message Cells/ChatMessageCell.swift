//
//  ChatMessageCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-21.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

class ChatMessageCell: BaseCell, UITextViewDelegate {

    static let incomingBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)

    static let outgoingBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)

    lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = ControllerConstants.defaultMessage
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.isSelectable = true
        textView.delegate = self
        return textView
    }()

    let textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()

    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ChatMessageCell.incomingBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        return imageView
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 8)
        label.textColor = .black
        return label
    }()

    override func setupViews() {
        super.setupViews()

        addSubview(textBubbleView)
        addSubview(messageTextView)

        textBubbleView.addSubview(bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "H:|[v0]|", views: bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)
        self.accessibilityIdentifier = ControllerConstants.TestKeys.chatCells

        self.backgroundColor = .clear
    }

    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange) -> Bool {
        return true
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }

}
