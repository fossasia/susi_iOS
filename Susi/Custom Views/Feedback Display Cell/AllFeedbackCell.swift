//
//  AllFeedbackCell.swift
//  Susi
//
//  Created by JOGENDRA on 28/06/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit
import Kingfisher

class AllFeedbackCell: UITableViewCell {

    @IBOutlet weak var gravatarImageView: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var feedbackDateLabel: UILabel!
    @IBOutlet weak var userFeedbackLabel: UILabel!

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
            if let userEmail = feedback?.email {
                setGravatar(from: userEmail)
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

    func setGravatar(from emailString: String) {
        let baseGravatarURL = "https://www.gravatar.com/avatar/"
        let emailMD5 = emailString.utf8.md5.rawValue
        let imageString = baseGravatarURL + emailMD5 + ".jpg"
        let imageURL = URL(string: imageString)
        gravatarImageView.kf.setImage(with: imageURL)
    }

}
