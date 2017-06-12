//
//  WebsearchAction.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-10.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import Foundation
import RealmSwift

class WebsearchAction: Object {
    dynamic var shortenedURL: String = ""
    dynamic var title: String = ""
    dynamic var desc: String = ""
    dynamic var image: String?

    convenience init(data: [String : AnyObject]) {
        self.init()

        if let shortenedUrl = data[Client.ChatKeys.ShortenedUrl] as? String,
            let title = data[Client.ChatKeys.Title] as? String,
            let desc = data[Client.ChatKeys.Description] as? String,
            let image = data[Client.ChatKeys.Image] as? String {
            self.shortenedURL = shortenedUrl
            self.title = title
            self.desc = desc
            self.image = image
        }

    }

}
