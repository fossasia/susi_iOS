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
    @objc dynamic var title: String = "No title"
    @objc dynamic var desc: String = "No description"
    @objc dynamic var link: String = "http://google.com"
    @objc dynamic var webData: WebsearchAction?

    convenience init(data: [String: AnyObject], title: String, description: String, link: String) {
        self.init()
        self.title = (data[title] as? String ?? "No title").trimmed
        self.desc = (data[description] as? String ?? "No description").trimmed
        self.link = (data[link] as? String ?? "http://google.com")
    }

    static func getRSSFeeds(data: [[String: AnyObject]], title: String, description: String, link: String, count: Int) -> List<RSSFeed> {
        let feeds = List<RSSFeed>()
        for index in (0..<count) {
            let feed = RSSFeed(data: data[index], title: title, description: description, link: link)
            feeds.append(feed)
        }
        return feeds
    }

}

class RSSAction: Object {
    @objc dynamic var count = 0
    var rssFeed = List<RSSFeed>()

    convenience init(data: [[String: AnyObject]], actionObject: [String: AnyObject]) {
        self.init()
        count = actionObject[Client.ChatKeys.Count] as? Int ?? 0

        if let title = actionObject[Client.ChatKeys.Title] as? String,
            let description = actionObject[Client.ChatKeys.Description] as? String,
            let link = actionObject[Client.ChatKeys.Link] as? String {
            rssFeed = RSSFeed.getRSSFeeds(data: data,
                                               title: title,
                                               description: description,
                                               link: link,
                                               count: count)
        }
    }
}
