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
    @objc dynamic var shortenedURL: String = Client.WebSearch.duckDuckGo
    @objc dynamic var title: String = Client.WebSearch.noData
    @objc dynamic var desc: String = Client.WebSearch.noDescription
    @objc dynamic var image: String?

    convenience init(data: [String: AnyObject]) {
        self.init()
        desc = data[Client.WebsearchKeys.Result] as? String ?? Client.WebSearch.noDescription
        image = data[Client.WebsearchKeys.Icon]?[Client.WebsearchKeys.Url] as? String
        title = data[Client.WebsearchKeys.Text] as? String ?? Client.WebSearch.noData
        shortenedURL = data[Client.WebsearchKeys.FirstURL] as? String ?? Client.WebSearch.duckDuckGo
    }

    static func getSearchResults(_ dictionary: [[String: AnyObject]]) -> List<WebsearchAction> {
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
