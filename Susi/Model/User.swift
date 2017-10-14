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

    let accessToken: String
    let message: String
    let expiryTime: Date
    let emailID: String

    init(dictionary: [String: AnyObject]) {
        accessToken = dictionary[Client.UserKeys.AccessToken] as? String ?? ""
        message = dictionary[Client.UserKeys.Message] as? String ?? ""
        expiryTime = Date() + (dictionary[Client.UserKeys.ValidSeconds] as? Int ?? 0).seconds
        emailID = dictionary[Client.UserKeys.EmailOfAccount] as? String ?? ""
    }

}
