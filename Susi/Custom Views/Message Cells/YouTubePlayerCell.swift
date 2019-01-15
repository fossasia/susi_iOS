//
//  YouTubePlayerCell.swift
//  Susi
//
//  Created by JOGENDRA on 04/07/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit
import Kingfisher

protocol PresentControllerDelegate: class {
    func loadNewScreen(controller: UIViewController)
}

class YouTubePlayerCell: ChatMessageCell {

    weak var delegate: PresentControllerDelegate?

    var message: Message? {
        didSet {
            addThumbnail()
        }
    }

    lazy var thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ControllerConstants.Images.placeholder
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(ControllerConstants.Images.youtubePlayButton, for: .normal)
        button.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func setupViews() {
        super.setupViews()
        setupCell()
        prepareForReuse()
    }

    func setupCell() {
        messageTextView.frame = CGRect.zero
        textBubbleView.frame = CGRect(x: 8, y: 0, width: 208, height: 158)
        textBubbleView.layer.borderWidth = 0.2
        textBubbleView.backgroundColor = .white
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailView.image = nil
    }

    func addThumbnail() {
        textBubbleView.addSubview(thumbnailView)
        textBubbleView.addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: thumbnailView)
        textBubbleView.addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: thumbnailView)
        self.downloadThumbnail()
        self.addPlayButton()
    }

    func addPlayButton() {
        thumbnailView.addSubview(playButton)
        playButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        playButton.centerXAnchor.constraint(equalTo: thumbnailView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: thumbnailView.centerYAnchor).isActive = true
    }

    func downloadThumbnail() {
        if let videoID = message?.videoData?.identifier {
            let thumbnailURLString = "https://img.youtube.com/vi/\(videoID)/default.jpg"
            let thumbnailURL = URL(string: thumbnailURLString)
            thumbnailView.kf.setImage(with: thumbnailURL, placeholder: ControllerConstants.Images.placeholder, options: nil, progressBlock: nil, completionHandler: nil)
        }
    }

    @objc func playVideo() {
        if let videoID = message?.videoData?.identifier {
            let playerVC = PlayerViewController(videoID: videoID)
            playerVC.modalPresentationStyle = .overFullScreen
            delegate?.loadNewScreen(controller: playerVC)
        }
    }

}
