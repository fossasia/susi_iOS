//
//  YouTubePlayerCell.swift
//  Susi
//
//  Created by JOGENDRA on 04/07/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit
import Kingfisher

class YouTubePlayerCell: ChatMessageCell {

    override func setupViews() {
        super.setupViews()
        setupCell()
    }

    func setupCell() {
        messageTextView.frame = CGRect.zero
        textBubbleView.frame = CGRect.zero
    }

}
