//
//  User.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-17.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import SwiftDate

class User: NSObject {

    var accessToken: String = ""
    var message: String = ""
    var expiryTime = Date()

    init(dictionary: [String:AnyObject]) {

        if let accessToken = dictionary[Client.UserKeys.AccessToken] as? String {
            self.accessToken = accessToken
        }

        if let message = dictionary[Client.UserKeys.Message] as? String {
            self.message = message
        }

        if let validSeconds = dictionary[Client.UserKeys.ValidSeconds] as? Int {
            self.expiryTime = Date() + validSeconds.seconds
        }

    }

}
