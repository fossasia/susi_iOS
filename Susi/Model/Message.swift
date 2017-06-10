//
//  Message.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-10.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import Foundation
import RealmSwift

enum ActionType: String {
    case answer
    case websearch
    case piechart
    case rss
    case table
    case map
    case anchor
}

class Message: Object {
    dynamic var queryDate = NSDate()
    dynamic var answerDate = NSDate()
    dynamic var query: String = ""
    dynamic var isSent = false
    dynamic var isMarked = false
    dynamic var fromUser = true
    let messages = List<Message>()

    convenience init(messageBody: String) {
        self.init()
        self.query = messageBody
    }

    convenience init(dictionary: [String : AnyObject]) {
        self.init()

        self.fromUser = false

        if let query = dictionary[Client.ChatKeys.Query] as? String {
            self.query = query
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let queryDate = dictionary[Client.ChatKeys.QueryDate] as? String,
            let answerDate = dictionary[Client.ChatKeys.AnswerDate] as? String {
            self.queryDate = dateFormatter.date(from: queryDate)! as NSDate
            self.answerDate = dateFormatter.date(from: answerDate)! as NSDate
        }

        if let answers = dictionary[Client.ChatKeys.Answers] as? [[String : AnyObject]] {
            if let actions = answers[0][Client.ChatKeys.Actions] as? [[String : AnyObject]] {
                for action in actions {
                    if let type = action[Client.ChatKeys.ResponseType] as? String,
                        let data = answers[0][Client.ChatKeys.Data] as? [[String : AnyObject]] {
                        if type == ActionType.answer.rawValue {
                            let answer = AnswerAction(data: action)
                            answer.queryDate = self.queryDate
                            answer.answerDate = self.answerDate
                            answer.query = self.query
                            self.messages.append(answer)
                        } else if type == ActionType.rss.rawValue {
                            let rss = RSSAction(data: data, actionObject: action)
                            rss.queryDate = self.queryDate
                            rss.answerDate = self.answerDate
                            rss.query = self.query
                            self.messages.append(rss)
                        } else if type == ActionType.map.rawValue {
                            let map = MapAction(data: action)
                            map.queryDate = self.queryDate
                            map.answerDate = self.answerDate
                            map.query = self.query
                            self.messages.append(map)
                        } else if type == ActionType.anchor.rawValue {
                            let anchor = AnchorAction(data: action)
                            anchor.queryDate = self.queryDate
                            anchor.answerDate = self.answerDate
                            anchor.query = self.query
                            self.messages.append(anchor)
                        } else if type == ActionType.table.rawValue {
                            let table = TableAction(data: data, actionObject: action)
                            table.queryDate = self.queryDate
                            table.answerDate = self.answerDate
                            table.query = self.query
                            self.messages.append(table)
                        }
                    }
                }
            }
        }

    }

}
