//
//  YouTubePlayerCell.swift
//  Susi
//
//  Created by JOGENDRA on 04/07/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit

class YouTubePlayerCell: ChatMessageCell {

    var player = PlayerView(frame: UIScreen.main.bounds)

    override func setupViews() {
        super.setupViews()
        setupCell()
        prepareForReuse()
    }

    func setupCell() {
        messageTextView.frame = CGRect.zero
        textBubbleView.frame = CGRect.zero
    }

    func loadVideo(with videoID: String) {
        player.tag = 24
        UIApplication.shared.keyWindow?.addSubview(player)
        player.play(videoID)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        player.removeFromSuperview()
        UIApplication.shared.keyWindow?.viewWithTag(24)?.removeFromSuperview()
        UIApplication.shared.keyWindow?.removeFromSuperview()
    }

}
