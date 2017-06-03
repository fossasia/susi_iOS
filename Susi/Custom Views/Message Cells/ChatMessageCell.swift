//
//  ChatMessageCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-21.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

class ChatMessageCell: BaseCell {

    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)

    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)

    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = ControllerConstants.defaultMessage
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.isSelectable = false
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
        imageView.image = ChatMessageCell.grayBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        return imageView
    }()

    override func setupViews() {
        super.setupViews()

        addSubview(textBubbleView)
        addSubview(messageTextView)

        textBubbleView.addSubview(bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "H:|[v0]|", views: bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)

    }

}
