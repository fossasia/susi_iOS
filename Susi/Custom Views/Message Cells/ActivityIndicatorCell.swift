//
//  ActivityIndicatorCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-07-24.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ActivityIndicatorCell: ChatMessageCell {

    let activityIndicator = NVActivityIndicatorView(frame: CGRect(), type: .ballPulse, color: .black, padding: 0)

    override func setupViews() {
        super.setupViews()

        self.bubbleImageView.image = ChatMessageCell.incomingBubbleImage
        self.bubbleImageView.tintColor = .white

        self.messageTextView.frame = CGRect.zero
        self.textBubbleView.frame = CGRect(x: 0, y: -4, width: 100, height: self.frame.height)
        activityIndicator.frame = textBubbleView.frame

        textBubbleView.addSubview(activityIndicator)
        textBubbleView.addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: activityIndicator)
        textBubbleView.addConstraintsWithFormat(format: "V:|-2-[v0]-2-|", views: activityIndicator)

        activityIndicator.startAnimating()
    }

}
