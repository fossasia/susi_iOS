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
    case indicatorView
}

class Message: Object {
    dynamic var queryDate = NSDate()
    dynamic var answerDate = NSDate()
    dynamic var message: String = ""
    dynamic var isSent = false
    dynamic var isMarked = false
    dynamic var fromUser = true
    dynamic var actionType = ActionType.answer.rawValue
    dynamic var answerData: AnswerAction?
    dynamic var rssData: RSSAction?
    dynamic var mapData: MapAction?
    dynamic var anchorData: AnchorAction?
    dynamic var tableData: TableAction?
    var websearchData = List<WebsearchAction>()
    dynamic var skill: String = ""

    convenience init(message: String) {
        self.init()
        self.message = message
        fromUser = true
    }

    static func getAllAction(data: [String : AnyObject]) -> List<Message> {
        let messages = List<Message>()
        var skill: String = ""

        if let answers = data[Client.ChatKeys.Answers] as? [[String : AnyObject]] {
            if let skills = answers[0][Client.ChatKeys.Skills] as? [String], skills.count > 0 {
                skill = skills.first!
            }

            if let actions = answers[0][Client.ChatKeys.Actions] as? [[String : AnyObject]] {
                for action in actions {

                    let message = Message()
                    message.fromUser = false
                    message.message = data[Client.ChatKeys.Query] as? String ?? ""
                    message.skill = skill

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    if let queryDate = data[Client.ChatKeys.QueryDate] as? String,
                        let answerDate = data[Client.ChatKeys.AnswerDate] as? String {
                        message.queryDate = dateFormatter.date(from: queryDate)! as NSDate
                        message.answerDate = dateFormatter.date(from: answerDate)! as NSDate
                    }

                    if let type = action[Client.ChatKeys.ResponseType] as? String,
                        let data = answers[0][Client.ChatKeys.Data] as? [[String : AnyObject]] {
                        if type == ActionType.answer.rawValue {
                            message.message = action[Client.ChatKeys.Expression] as? String ?? ""
                            message.actionType = ActionType.answer.rawValue
                            message.answerData = AnswerAction(action: action)
                        } else if type == ActionType.rss.rawValue {
                            message.actionType = ActionType.rss.rawValue
                            message.rssData = RSSAction(data: data, actionObject: action)
                        } else if type == ActionType.map.rawValue {
                            message.actionType = ActionType.map.rawValue
                            message.mapData = MapAction(action: action)
                        } else if type == ActionType.anchor.rawValue {
                            message.actionType = ActionType.anchor.rawValue
                            message.anchorData = AnchorAction(action: action)
                            message.message = message.anchorData!.text
                        } else if type == ActionType.table.rawValue {
                            message.actionType = ActionType.table.rawValue
                            message.tableData = TableAction(data: data, actionObject: action)
                        } else if type == ActionType.websearch.rawValue {
                            message.actionType = ActionType.websearch.rawValue
                            message.message = action[Client.ChatKeys.Query] as? String ?? ""
                        }
                    }
                    messages.append(message)
                }
            }
        }

        return messages
    }

    static func getMessagesFromMemory(_ cognitions: [[String : AnyObject]]) -> List<Message> {
        let messages = List<Message>()

        for cognition in cognitions {
            if let query = cognition[Client.ChatKeys.Query] as? String {
                let message = Message(message: query)
                messages.append(message)
            }
            let actionMessages = Message.getAllAction(data: cognition)
            for message in actionMessages {
                messages.append(message)
            }
        }
        return messages
    }

}
