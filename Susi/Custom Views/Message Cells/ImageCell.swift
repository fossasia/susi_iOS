//
//  ImageCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Kingfisher

class ImageCell: ChatMessageCell {

    var message: Message? {
        didSet {
            addImageView()
            downloadImage()
        }
    }

    let imagView: AnimatedImageView = {
        let imageView = AnimatedImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()

    override func setupViews() {
        super.setupViews()
        setupView()
    }

    func addImageView() {
        messageTextView.text = ""
        textBubbleView.addSubview(imagView)
        textBubbleView.addConstraintsWithFormat(format: "H:|-8-[v0]-5-|", views: imagView)
        textBubbleView.addConstraintsWithFormat(format: "V:|-4-[v0]-5-|", views: imagView)
    }

    func setupView() {
        let width = Int(frame.width / 3)
        let height = 100
        messageTextView.frame = CGRect.zero
        textBubbleView.frame = CGRect(x: 4, y: 0, width: width + 40, height: height)
    }

    func downloadImage() {
        if let imageString = message?.message, imageString.isImage() {
            if let url = URL(string: imageString) {
                imagView.kf.setImage(with: url, placeholder: ControllerConstants.Images.placeholder, options: nil, progressBlock: nil, completionHandler: nil)
            }
        }
    }

}
