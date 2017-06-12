//
//  RSSAction.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-10.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import Foundation
import RealmSwift

class RSSFeed: Object {
    dynamic var title: String = "No title"
    dynamic var desc: String = "No description"
    dynamic var link: String = "http://google.com"
    dynamic var webData: WebsearchAction?

    convenience init(data: [String : AnyObject], title: String, description: String, link: String) {
        self.init()

        if let title = data[title] as? String, !title.isEmpty {
            self.title = title.trimmed
        }
        if let desc = data[description] as? String, !desc.isEmpty {
            self.desc = desc.trimmed
        }
        if let link = data[link] as? String, !link.isEmpty {
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

class RSSAction: Object {
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
