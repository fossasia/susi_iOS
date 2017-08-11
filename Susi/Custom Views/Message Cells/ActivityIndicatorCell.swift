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

    let activityIndicator = NVActivityIndicatorView(frame: CGRect(), type: .ballPulse, color: .clear, padding: 0)

    override func setupViews() {
        super.setupViews()
        setupTheme()

        messageTextView.frame = CGRect.zero
        textBubbleView.frame = CGRect(x: 4, y: -4, width: 100, height: self.frame.height)
        activityIndicator.frame = textBubbleView.frame

        textBubbleView.addSubview(activityIndicator)
        textBubbleView.addConstraintsWithFormat(format: "H:|[v0]|", views: activityIndicator)
        textBubbleView.addConstraintsWithFormat(format: "V:|[v0]|", views: activityIndicator)

        activityIndicator.startAnimating()
        textBubbleView.borderWidth = 0.2
    }

    func setupTheme() {
        textBubbleView.backgroundColor = .white
        activityIndicator.color = UIColor.hexStringToUIColor(hex: "#757575")
    }

}
