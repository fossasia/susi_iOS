//
//  Ratings.swift
//  Susi
//
//  Created by JOGENDRA on 14/06/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import Foundation

class Ratings: NSObject {
    var oneStar: Int = 0
    var twoStar: Int = 0
    var threeStar: Int = 0
    var fourStar: Int = 0
    var fiveStar: Int = 0
    var totalStar: Int = 0
    var average: Double = 0.0

    convenience init(dictionary: [String: AnyObject]) {
        self.init()
        oneStar = dictionary[Client.FiveStarRating.oneStar] as? Int ?? 0
        twoStar = dictionary[Client.FiveStarRating.twoStar] as? Int ?? 0
        threeStar = dictionary[Client.FiveStarRating.threeStar] as? Int ?? 0
        fourStar = dictionary[Client.FiveStarRating.fourStar] as? Int ?? 0
        fiveStar = dictionary[Client.FiveStarRating.fiveSatr] as? Int ?? 0
        totalStar = dictionary[Client.FiveStarRating.totalStar] as? Int ?? 0
        average = dictionary[Client.FiveStarRating.average] as? Double ?? 0.0
    }
}
