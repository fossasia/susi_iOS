//
//  Message.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

struct Message {

    var body: String? = ""
    var created_at = Date()
    var isBot = false
    var responseType: ResponseTypes = .answer

    var mapData: MapData?

    struct MapData {
        var longitude: Double
        var latitude: Double
        var zoom: Int
    }

    var websearchData: WebsearchResult?
    var query: String?

    enum ResponseTypes: String {
        case answer = "answer"
        case map = "map"
        case websearch = "websearch"
    }

    init(_ body: String) {
        self.body = body
    }

    init(dictionary: [String : AnyObject], isBot: Bool) {

        if let created_at = dictionary[Client.ChatKeys.AnswerDate] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"

            self.created_at = dateFormatter.date(from: created_at)!
        }

        if let body = dictionary[Client.ChatKeys.Answers] as? [[String : AnyObject]] {
            if let actions = body[0][Client.ChatKeys.Actions] as? NSArray {
                if let response = actions[0] as? [String : String] {
                    self.body = response[Client.ChatKeys.Expression]!
                }

                if let responses = actions as? [[String : String]] {

                    for response in responses {
                        let responseType = response[Client.ChatKeys.ResponseType]

                        if responseType == ResponseTypes.answer.rawValue {
                            debugPrint("Inside Answer")
                            self.body = response[Client.ChatKeys.Expression]

                        } else if responseType == ResponseTypes.map.rawValue {
                            debugPrint("Inside Map")
                            self.responseType = ResponseTypes.map

                            if let latitude = response[Client.ChatKeys.Latitude],
                                let longitude = response[Client.ChatKeys.Longitude],
                                let zoom = response[Client.ChatKeys.Zoom] {

                                self.mapData = MapData(longitude: Double(longitude)!, latitude: Double(latitude)!, zoom: Int(zoom)!)
                            }

                            self.body = self.body?.components(separatedBy: " ").dropLast().joined(separator: " ")

                        } else if responseType == ResponseTypes.websearch.rawValue {
                            debugPrint("Inside Websearch")
                            self.responseType = ResponseTypes.websearch
                            self.query = response[Client.ChatKeys.Query]

                        } else {
                            debugPrint("Inside None")
                        }
                    }

                }

            }
        }

        self.isBot = isBot
    }

    static func getMessageFromResponse(_ result: [String : AnyObject], isBot: Bool) -> Message {
        let message = Message(dictionary: result, isBot: isBot)

        return message
    }

}
