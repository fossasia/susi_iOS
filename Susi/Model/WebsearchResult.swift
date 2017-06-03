//
//  WebsearchResult.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-21.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

class WebsearchResult: NSObject {

    var image: String = Client.WebSearch.image
    var info: String = Client.WebSearch.noData
    var url: String = Client.WebSearch.duckDuckGo
    var query: String = ""

    init(dictionary: [String:AnyObject]) {

        if let relatedTopics = dictionary[Client.WebsearchKeys.RelatedTopics] as? [[String : AnyObject]] {

            if relatedTopics.count > 0 {

                if let icon = relatedTopics[0][Client.WebsearchKeys.Icon] as? [String : String] {
                    if let image = icon[Client.WebsearchKeys.Url] {
                        self.image = image
                    }
                }

                if let url = relatedTopics[0][Client.WebsearchKeys.FirstURL] as? String {
                    self.url = url
                }

                if let info = relatedTopics[0][Client.WebsearchKeys.Text] as? String {
                    self.info = info
                }

                if let query = dictionary[Client.WebsearchKeys.Heading] as? String {
                    let string = query.lowercased().replacingOccurrences(of: " ", with: "+")
                    self.query = string
                }

            }

        }

    }

}
