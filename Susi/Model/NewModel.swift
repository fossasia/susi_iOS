//
//  NewModel.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-08.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import RealmSwift
import Realm
import Foundation

enum ActionType: String {
    case answer
    case websearch
    case piechart
    case rss
    case table
    case map
}

class MessageNew: Object {
    let actionType = [String]()
    dynamic var queryDate = NSDate()
    dynamic var answerDate = NSDate()
    dynamic var query: String = ""
    let data = List<Object>()
    dynamic var isSent = false
    dynamic var isMarked = false

    convenience init(dictionary: [String : AnyObject]) {
        self.init()

        if let answers = dictionary[Client.ChatKeys.Answers] as? [[String : AnyObject]] {
            if let actions = answers[0][Client.ChatKeys.Actions] as? [[String : AnyObject]] {
                for action in actions {
                    if let type = action[Client.ChatKeys.ResponseType] as? String {
                        if type == ActionType.answer.rawValue {
                            debugPrint(Answer(data: action))
                        } else if type == ActionType.rss.rawValue {
                            debugPrint(RSS(data: answers[0][Client.ChatKeys.Data] as! [[String : AnyObject]], actionObject: action))
                        }
                    }
                }
            }
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
        for d in data {
            let feed = RSSFeed(data: d, title: title, description: description, link: link)
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
            self.rssFeed = RSSFeed.getRSSFeeds(data: data, title: title, description: description, link: link)
        }
    }
}

class WebsearchData: Object {
    dynamic var shortenedURL: String = ""
    dynamic var title: String = ""
    dynamic var desc: String = ""
    dynamic var image: String = ""
}

class Table: Object {
    dynamic var size: Int = 0
    dynamic var columns = [String]()
}

class Anchor: Object {
    dynamic var link: String = ""
    dynamic var text: String = ""
}

class Map: Object {
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var zoom: Double = 0.0
}
