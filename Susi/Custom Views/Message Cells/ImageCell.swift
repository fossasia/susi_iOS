//
//  ImageCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Kingfisher
import Material
import SwiftDate

class ImageCell: ChatMessageCell {

    var message: Message? {
        didSet {
            addImageView()
            downloadImage()
        }
    }

    let imageView: AnimatedImageView = {
        let imageView = AnimatedImageView()
        imageView.image = ControllerConstants.Images.placeholder
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    lazy var thumbUpIcon: IconButton = {
        let button = IconButton()
        button.image = ControllerConstants.Images.thumbsUp
        button.addTarget(self, action: #selector(sendFeedback(sender:)), for: .touchUpInside)
        return button
    }()

    lazy var thumbDownIcon: IconButton = {
        let button = IconButton()
        button.image = ControllerConstants.Images.thumbsDown
        button.addTarget(self, action: #selector(sendFeedback(sender:)), for: .touchUpInside)
        return button
    }()

    override func setupViews() {
        super.setupViews()
        setupView()
    }

    func addImageView() {
        textBubbleView.addSubview(imageView)
        textBubbleView.addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: imageView)
        textBubbleView.addConstraintsWithFormat(format: "V:|-4-[v0]-20-|", views: imageView)
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openImage))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
        addBottomView()
    }

    @objc func openImage() {
        if let imageURL = message?.answerData?.expression {
            if let url = URL(string: imageURL) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    func setupView() {
        messageTextView.frame = CGRect.zero
        textBubbleView.frame = CGRect(x: 8, y: 0, width: 228, height: 173)
        textBubbleView.backgroundColor = .white
        textBubbleView.layer.borderWidth = 0.2
    }

    func downloadImage() {
        if let imageString = message?.answerData?.expression, imageString.isImage() {
            if let url = URL(string: imageString) {
                imageView.kf.setImage(with: url, placeholder: ControllerConstants.Images.placeholder, options: nil, progressBlock: nil, completionHandler: nil)
            }
        }
    }

    func addBottomView() {
        if let absoluteQueryDate = message?.queryDate as Date? {
            let date = DateInRegion(absoluteDate: absoluteQueryDate)
            let dateString = date.string(format: .custom("h:mm a"))
            timeLabel.text = dateString
            textBubbleView.addSubview(timeLabel)
        }

        // Add subviews
        textBubbleView.addSubview(thumbUpIcon)
        textBubbleView.addSubview(thumbDownIcon)
        thumbUpIcon.isUserInteractionEnabled = true
        thumbDownIcon.isUserInteractionEnabled = true
        thumbUpIcon.tintColor = UIColor(white: 0.1, alpha: 0.7)
        thumbDownIcon.tintColor = UIColor(white: 0.1, alpha: 0.7)

        // Constraints
        textBubbleView.addConstraintsWithFormat(format: "H:[v0]-4-[v1(16)]-2-[v2(16)]-8-|", views: timeLabel, thumbUpIcon, thumbDownIcon)
        textBubbleView.addConstraintsWithFormat(format: "V:[v0(16)]-2-|", views: thumbUpIcon)
        textBubbleView.addConstraintsWithFormat(format: "V:[v0(16)]-2-|", views: thumbDownIcon)
        textBubbleView.addConstraintsWithFormat(format: "V:[v0]-4-|", views: timeLabel)
    }

    @objc func sendFeedback(sender: IconButton) {
        let feedback: String
        if sender == thumbUpIcon {
            thumbDownIcon.tintColor = UIColor(white: 0.1, alpha: 0.7)
            thumbUpIcon.isUserInteractionEnabled = false
            thumbDownIcon.isUserInteractionEnabled = true
            feedback = "positive"
        } else {
            thumbUpIcon.tintColor = UIColor(white: 0.1, alpha: 0.7)
            thumbDownIcon.isUserInteractionEnabled = false
            thumbUpIcon.isUserInteractionEnabled = true
            feedback = "negative"
        }
        sender.tintColor = UIColor.thumbsSelectedColor()

        let skillComponents = message?.skill.components(separatedBy: "/")
        if skillComponents?.count == 7 {
            let params: [String: AnyObject] = [
                Client.FeedbackKeys.model: skillComponents![3] as AnyObject,
                Client.FeedbackKeys.group: skillComponents![4] as AnyObject,
                Client.FeedbackKeys.language: skillComponents![5] as AnyObject,
                Client.FeedbackKeys.skill: skillComponents![6].components(separatedBy: ".").first as AnyObject,
                Client.FeedbackKeys.rating: feedback as AnyObject
            ]

            Client.sharedInstance.sendFeedback(params) { (success, _) in
                DispatchQueue.main.async {
                    if success {
                        self.removeUpDownThumbs()
                    }
                }
            }

            var feedbackLogParams: [String: AnyObject] = [
                Client.FeedbackKeys.model: skillComponents![3] as AnyObject,
                Client.FeedbackKeys.group: skillComponents![4] as AnyObject,
                Client.FeedbackKeys.language: skillComponents![5] as AnyObject,
                Client.FeedbackKeys.skill: skillComponents![6].components(separatedBy: ".").first as AnyObject,
                Client.FeedbackKeys.rating: feedback as AnyObject,
                Client.FeedbackKeys.countryCode: Locale.current.regionCode as AnyObject,
                Client.FeedbackKeys.deviceType: ControllerConstants.deviceType as AnyObject,
                Client.FeedbackKeys.susiReply: message?.message as AnyObject
            ]

            if let userQuery = UserDefaults.standard.value(forKey: ControllerConstants.UserDefaultsKeys.userQuery) {
                feedbackLogParams[Client.FeedbackKeys.userQuery] = userQuery as AnyObject
            }

            if let countryName = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: Locale.current.regionCode as Any) {
                feedbackLogParams[Client.FeedbackKeys.countryName] = countryName as AnyObject
            }

            Client.sharedInstance.sendFeedbackLog(feedbackLogParams) { (success, _) in
                DispatchQueue.main.async {
                    if success {
                        self.removeUpDownThumbs()
                    }
                }
            }
        }
    }

    func removeUpDownThumbs() {
        thumbUpIcon.removeFromSuperview()
        thumbDownIcon.removeFromSuperview()
        timeLabel.rightAnchor.constraint(equalTo: textBubbleView.rightAnchor, constant: -16).isActive = true
    }

}
