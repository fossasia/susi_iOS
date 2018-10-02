//
//  FeedbackDisplayCell.swift
//  Susi
//
//  Created by JOGENDRA on 27/06/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit

class FeedbackDisplayCell: UITableViewCell {

    @IBOutlet weak var gravatarImageView: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userFeedbackLabel: UILabel!
    @IBOutlet weak var feedbackDateLabel: UILabel!

    var feedback: Feedback? {
        didSet {
            if let username = feedback?.username, !username.isEmpty {
                userEmailLabel.text = username
            } else {
                if let userEmail = feedback?.email, let emailIndex = userEmail.range(of: "@")?.upperBound {
                    userEmailLabel.text = String(userEmail.prefix(upTo: emailIndex)) + "..."
                }
            }
            feedbackDateLabel.text = feedback?.timeStamp.getFirstChar(10)
            userFeedbackLabel.text = feedback?.feedbackString
            if let avatarURLString = feedback?.avatar {
                let imageURL = URL(string: avatarURLString)
                gravatarImageView.kf.setImage(with: imageURL)
            }
            roundedCorner()
        }
    }

    func roundedCorner() {
        gravatarImageView.layer.cornerRadius = 22.0
        gravatarImageView.layer.borderWidth = 1.0
        gravatarImageView.layer.borderColor = UIColor.iOSGray().cgColor
        gravatarImageView.layer.masksToBounds = true
    }

}
