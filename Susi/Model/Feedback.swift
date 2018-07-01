//
//  Feedback.swift
//  Susi
//
//  Created by JOGENDRA on 28/06/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import Foundation

class Feedback: NSObject {
    var feedbackString: String = ""
    var email: String = ""
    var timeStamp: String = ""

    convenience init(dictionary: [String: AnyObject]) {
        self.init()
        feedbackString = dictionary["feedback"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        timeStamp = dictionary["timestamp"] as? String ?? ""
    }

    static func getAllFeedback(_ feedbacks: [Dictionary<String, AnyObject>]) -> [Feedback] {
        var feedbackData = [Feedback]()
        for feedback in feedbacks {
            print(feedback)
            let newFeedback = Feedback(dictionary: feedback)
            feedbackData.append(newFeedback)
        }
        return feedbackData
    }

}
