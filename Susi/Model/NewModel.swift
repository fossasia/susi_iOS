//
//  NewModel.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-08.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import RealmSwift
import Foundation
import Realm

enum ActionType: String {
    case answer
    case websearch
    case piechart
    case rss
    case table
    case map
    case anchor
}

class Action: Object {
    dynamic var action: String = ActionType.answer.rawValue
    convenience init(action: String) {
        self.init()
        self.action = action
    }
}

class MessageNew: Object {
    var actionType = List<Action>()
    dynamic var queryDate = NSDate()
    dynamic var answerDate = NSDate()
    dynamic var query: String = ""
    var data = List<Object>()
    dynamic var isSent = false
    dynamic var isMarked = false

    convenience init(messageBody: String) {
        self.init()
        self.query = messageBody
    }

    convenience init(dictionary: [String : AnyObject]) {
        self.init()

        if let answers = dictionary[Client.ChatKeys.Answers] as? [[String : AnyObject]] {
            if let actions = answers[0][Client.ChatKeys.Actions] as? [[String : AnyObject]] {
                for action in actions {
                    if let type = action[Client.ChatKeys.ResponseType] as? String,
                        let data = answers[0][Client.ChatKeys.Data] as? [[String : AnyObject]] {
                        if type == ActionType.answer.rawValue {
                            self.actionType.append(Action(action: ActionType.answer.rawValue))
                            self.data.append(Object(value: Answer(data: action)))
                        } else if type == ActionType.rss.rawValue {
                            self.actionType.append(Action(action: ActionType.rss.rawValue))
                            self.data.append(Object(value: RSS(data: data, actionObject: action)))
                        } else if type == ActionType.map.rawValue {
                            self.actionType.append(Action(action: ActionType.map.rawValue))
                            self.data.append(Object(value: Map(data: action)))
                        } else if type == ActionType.anchor.rawValue {
                            self.actionType.append(Action(action: ActionType.anchor.rawValue))
                            self.data.append(Object(value: Anchor(data: action)))
                        } else if type == ActionType.table.rawValue {
                            self.actionType.append(Action(action: ActionType.table.rawValue))
                            self.data.append(Object(value: Table(data: data, actionObject: action)))
                        }
                    }
                }
            }
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        if let queryDate = dictionary[Client.ChatKeys.QueryDate] as? String,
            let answerDate = dictionary[Client.ChatKeys.AnswerDate] as? String {
            self.queryDate = dateFormatter.date(from: queryDate)! as NSDate
            self.answerDate = dateFormatter.date(from: answerDate)! as NSDate
        }

    }

}

class Answer: Object {
    dynamic var expression: String = ""

    convenience init(data: [String : AnyObject]) {
        self.init()

        if let expression = data[Client.ChatKeys.Expression] as? String {
            self.expression = expression
        }
    }
}

class RSSFeed: Object {
    dynamic var title: String = "No title"
    dynamic var desc: String = "No description"
    dynamic var link: String = "http://google.com"
    dynamic var webData: WebsearchData?

    convenience init(data: [String : AnyObject], title: String, description: String, link: String) {
        self.init()

        if let title = data[title] as? String {
            self.title = title.trimmed
        }
        if let desc = data[description] as? String {
            self.desc = desc.trimmed
        }
        if let link = data[link] as? String {
            self.link = link
        }
    }

    static func getRSSFeeds(data: [[String : AnyObject]], title: String, description: String, link: String) -> List<RSSFeed> {
        let feeds = List<RSSFeed>()
        for feedData in data {
            let feed = RSSFeed(data: feedData, title: title, description: description, link: link)
            feeds.append(feed)
        }
        return feeds
    }

}

class RSS: Object {
    dynamic var count = 0
    var rssFeed = List<RSSFeed>()

    convenience init(data: [[String : AnyObject]], actionObject: [String : AnyObject]) {
        self.init()

        if let count = actionObject[Client.ChatKeys.Count] as? Int {
            self.count = count
        }

        if let title = actionObject[Client.ChatKeys.Title] as? String,
            let description = actionObject[Client.ChatKeys.Description] as? String,
            let link = actionObject[Client.ChatKeys.Link] as? String {
            self.rssFeed = RSSFeed.getRSSFeeds(data: data,
                                               title: title,
                                               description: description,
                                               link: link)
        }
    }
}

class WebsearchData: Object {
    dynamic var shortenedURL: String = ""
    dynamic var title: String = ""
    dynamic var desc: String = ""
    dynamic var image: String = ""
}

class Column: Object {
    dynamic var original: String = ""
    dynamic var changed: String = ""

    convenience init(key: String, value: String) {
        self.init()

        self.original = key
        self.changed = value
    }

    static func getColumns(columns: [String : String]) -> List<Column> {
        let cData = List<Column>()
        for column in columns {
            cData.append(Column(key: column.key, value: column.value))
        }
        return cData
    }

}

class TableData: Object {
    dynamic var data: String = ""

    convenience init(data: [String : AnyObject]) {
        self.init()

        self.data = "\(data)"
    }

    static func getTableData(data: [[String : AnyObject]]) -> List<TableData> {
        let tData = List<TableData>()
        for record in data {
            let d = TableData(data: record)
            tData.append(d)
        }
        return tData
    }

}

class Table: Object {
    dynamic var size: Int = 0
    var columns = List<Column>()
    var tableData = List<TableData>()

    convenience init(data: [[String : AnyObject]], actionObject: [String : AnyObject]) {
        self.init()

        if let count = actionObject[Client.ChatKeys.Count] as? Int, count > 0 {
            self.size = count
        }

        if let columns = actionObject[Client.ChatKeys.Columns] as? [String : String] {
            self.columns = Column.getColumns(columns: columns)
        }

        self.tableData = TableData.getTableData(data: data)
    }

}

class Anchor: Object {
    dynamic var link: String = ""
    dynamic var text: String = ""

    convenience init(data: [String : AnyObject]) {
        self.init()

        if let link = data[Client.ChatKeys.Link] as? String,
            let text = data[Client.ChatKeys.Text] as? String {
            self.link = link
            self.text = text
        }
    }
}

class Map: Object {
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var zoom: Int = 0

    convenience init(data: [String : AnyObject]) {
        self.init()

        if let latitude = data[Client.ChatKeys.Latitude] as? String,
            let longitude = data[Client.ChatKeys.Longitude] as? String,
            let zoom = data[Client.ChatKeys.Zoom] as? String {
            self.longitude = Double(longitude)!
            self.latitude = Double(latitude)!
            self.zoom = Int(zoom)!
        }

    }

}
