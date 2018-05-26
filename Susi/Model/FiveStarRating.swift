//
//  FiveStarRating.swift
//  Susi
//
//  Created by JOGENDRA on 26/05/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import Foundation

class FiveStarRating: NSObject {
    var oneStar: Int = 0
    var twoStar: Int = 0
    var threeStar: Int = 0
    var fourStar: Int = 0
    var fiveStar: Int = 0
    var positive: Int = 0
    var negative: Int = 0
    var average: Double = 0.0

    init(dictionary: [String: AnyObject]) {
        super.init()
        oneStar = Int(dictionary[Client.FiveStarRating.oneStar] as? String ?? "0")
        twoStar = Int(dictionary[Client.FiveStarRating.twoStar] as? String ?? "0")
        threeStar = Int(dictionary[Client.FiveStarRating.threeStar] as? String ?? "0")
        fourStar = Int(dictionary[Client.FiveStarRating.fourStar] as? String ?? "0")
        fiveStar = Int(dictionary[Client.FiveStarRating.fiveSatr] as? String ?? "0")
        positive = Int(dictionary[Client.FiveStarRating.positive] as? String ?? "0")
        negative = Int(dictionary[Client.FiveStarRating.negative] as? String ?? "0")
        average = Double(dictionary[Client.FiveStarRating.average] as? String ?? "0.0")
    }
}
