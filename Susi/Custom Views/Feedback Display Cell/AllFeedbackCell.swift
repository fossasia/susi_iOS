//
//  AllFeedbackCell.swift
//  Susi
//
//  Created by JOGENDRA on 28/06/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit

class AllFeedbackCell: UITableViewCell {

    @IBOutlet weak var userPlaceholderLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var feedbackDateLabel: UILabel!
    @IBOutlet weak var userFeedbackLabel: UILabel!

    var feedback: Feedback? {
        didSet {
            userPlaceholderLabel.text = feedback?.email.getFirstTwoChar().uppercased()
            userEmailLabel.text = feedback?.email
            feedbackDateLabel.text = feedback?.timeStamp.getFirstChar(10)
            userFeedbackLabel.text = feedback?.feedbackString
            roundedCorner()
        }
    }

    func roundedCorner() {
        userPlaceholderLabel.layer.cornerRadius = 22.0
        userPlaceholderLabel.layer.masksToBounds = true
    }

}
