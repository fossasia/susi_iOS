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
    dynamic var shortenedURL: String = Client.WebSearch.duckDuckGo
    dynamic var title: String = Client.WebSearch.noData
    dynamic var desc: String = Client.WebSearch.noDescription
    dynamic var image: String?

    convenience init(data: [String:AnyObject]) {
        self.init()

        if let result = data[Client.WebsearchKeys.Result] as? String, !result.isEmpty {
            self.desc = result
        }

        if let icon = data[Client.WebsearchKeys.Icon] as? [String : AnyObject] {
            if let url = icon[Client.WebsearchKeys.Url] as? String, !url.isEmpty {
                self.image = url
            }
        }

        if let text = data[Client.WebsearchKeys.Text] as? String {
            self.title = text
        }

        if let firstUrl = data[Client.WebsearchKeys.FirstURL] as? String {
            self.shortenedURL = firstUrl
        }

    }

    static func getSearchResults(_ dictionary: [[String : AnyObject]]) -> List<WebsearchAction> {
        let results = List<WebsearchAction>()
        for record in dictionary {
            if let _ = record[Client.WebsearchKeys.Result] as? String {
                let websearchAction = WebsearchAction(data: record)
                results.append(websearchAction)
            }
        }
        return results
    }

}
