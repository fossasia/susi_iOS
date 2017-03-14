//
//  Message.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

struct Message {
    
    var body: String? = ""
     var created_at = Date()
     var isBot = false
    
    init(_ body: String) {
        self.body = body
    }
    
    init(dictionary: [String : AnyObject], isBot: Bool) {
        
        if let created_at = dictionary[Client.ChatKeys.AnswerDate] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
            
            self.created_at = dateFormatter.date(from: created_at)!
        }
        
        if let body = dictionary[Client.ChatKeys.Answers] as? [[String : AnyObject]] {
            if let actions = body[0][Client.ChatKeys.Actions] as? NSArray {
                if let response = actions[0] as? [String : String] {
                    self.body = response[Client.ChatKeys.Expression]!
                }
            }
        }
        
        self.isBot = isBot
    }
    
    static func getMessageFromResponse(_ result: [String : AnyObject], isBot: Bool) -> Message {
        let message = Message(dictionary: result, isBot: isBot)
        
        return message
    }
    
}
