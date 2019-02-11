//
//  IncomingChatCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Kingfisher
import MapKit
import SwiftDate
import NVActivityIndicatorView
import Material

class IncomingBubbleCell: ChatMessageCell, MKMapViewDelegate {

    var message: Message?
    
    var updatedHeight: CGFloat = 40.0

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
        setupTheme()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame.size.height = updatedHeight + 40
        self.frame.size.height = updatedHeight + 38
     }

    func setupCell(_ estimatedFrame: CGRect, _ viewFrame: CGRect) {
        if let message = message {
            updatedHeight = estimatedFrame.height
            if message.actionType == ActionType.answer.rawValue {
                messageTextView.frame = CGRect(x: 12, y: 4, width: max(estimatedFrame.width + 26, viewFrame.width / 3), height: estimatedFrame.height + 20)
                textBubbleView.frame = CGRect(x: 8, y: 0, width: max(estimatedFrame.width + 40, viewFrame.width / 3), height: estimatedFrame.height + 36)

                let attributedString = NSMutableAttributedString(string: message.message)
                if message.message.containsURL() {
                    _ = attributedString.setAsLink(textToFind: message.message.extractFirstURL(),
                                                   linkURL: message.message.extractFirstURL(), text: message.message)
                } else {
                    attributedString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)],
                                                   range: NSRange(location: 0, length: message.message.count))
                }

                messageTextView.attributedText = attributedString
                addBottomView()
            }
        }
    }

    func setupTheme() {
        textBubbleView.layer.borderWidth = 0.5
        textBubbleView.backgroundColor = .white
        messageTextView.textColor = .black
        timeLabel.textColor = .black
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
        self.layoutIfNeeded()
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
