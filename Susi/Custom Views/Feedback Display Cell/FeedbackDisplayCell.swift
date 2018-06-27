//
//  FeedbackDisplayCell.swift
//  Susi
//
//  Created by JOGENDRA on 27/06/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit

class FeedbackDisplayCell: UITableViewCell {

    @IBOutlet weak var userPlaceHolderLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userFeedbackLabel: UILabel!
    @IBOutlet weak var feedbackDateLabel: UILabel!

    var feedback: Feedback? {
        didSet {
            userPlaceHolderLabel.text = feedback?.email.getFirstTwoChar().uppercased()
            userEmailLabel.text = feedback?.email
            feedbackDateLabel.text = feedback?.timeStamp.getFirstChar(10)
            userFeedbackLabel.text = feedback?.feedbackString
            initialUISetups()
        }
    }

    func initialUISetups() {
        userPlaceHolderLabel.layer.cornerRadius = 22.0
        userPlaceHolderLabel.layer.masksToBounds = true
    }

}
