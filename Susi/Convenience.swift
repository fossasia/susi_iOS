//
//  Convenience.swift
//  Susi
//
//  Created by Chashmeet Singh on 31/01/17.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import Foundation
import Alamofire

extension Client {

    // MARK: - Auth Methods

    func loginUser(_ params: [String : AnyObject], _ completion: @escaping(_ user: User?, _ success: Bool, _ error: String) -> Void) {

        _ = makeRequest(.post, [:], Methods.Login, parameters: params, completion: { (results, message) in

            if let error = message {
                print(error.localizedDescription)
                completion(nil, false, ResponseMessages.InvalidParams)
                return
            } else if let results = results as? [String : AnyObject] {

                let user = User(dictionary: results)

                UserDefaults.standard.set(results, forKey: "user")
                completion(user, true, user.message)
                return
            }

        })

    }

    func registerUser(_ params: [String : AnyObject], _ completion: @escaping(_ success: Bool, _ error: String) -> Void) {

        _ = makeRequest(.post, [:], Methods.Register, parameters: params, completion: { (results, message) in

            if let error = message {
                print(error.localizedDescription)
                completion(false, ResponseMessages.ServerError)
                return
            } else if let results = results {

                guard let successMessage = results[UserKeys.Message] as? String else {
                    completion(false, ResponseMessages.InvalidParams)
                    return
                }

                completion(true, successMessage)
                return
            }

        })

    }

    func logoutUser(_ completion: @escaping(_ success: Bool, _ error: String) -> Void) {

        UserDefaults.standard.removeObject(forKey: "user")
        completion(true, ResponseMessages.SignedOut)

    }

    // MARK: - Chat Methods

    func queryResponse(_ params: [String : AnyObject], _ completion: @escaping(_ response: Message?, _ success: Bool, _ error: String?) -> Void) {

        _ = makeRequest(.get, [:], Methods.Chat, parameters: params, completion: { (results, message) in

            if let error = message {
                print(error.localizedDescription)
                completion(nil, false, ResponseMessages.ServerError)
                return
            } else if let results = results {

                guard let response = results as? [String : AnyObject] else {
                    completion(nil, false, ResponseMessages.InvalidParams)
                    return
                }

                let message = Message.getMessageFromResponse(response, isBot: true)

                completion(message, true, nil)
                return

            }

        })

    }

    func websearch(_ params: [String : AnyObject], _ completion: @escaping(_ response: WebsearchResult?, _ success: Bool, _ error: String?) -> Void) {

        _ = customRequest(.get, [:], CustomURLs.DuckDuckGo, params, completion: { (results, message) in

            if let error = message {
                print(error.localizedDescription)
                completion(nil, false, ResponseMessages.ServerError)
                return
            } else if let results = results {

                guard let response = results as? [String : AnyObject] else {
                    completion(nil, false, ResponseMessages.InvalidParams)
                    return
                }

                let searchResult = WebsearchResult(dictionary: response)

                completion(searchResult, true, nil)
                return

            }

        })

    }

    func searchYotubeVideos(_ query: String, _ completion: @escaping(_ response: String?, _ success: Bool, _ error: String?) -> Void) {

        let params = [
            YoutubeParamKeys.Key: YoutubeParamValues.Key,
            YoutubeParamKeys.Part: YoutubeParamValues.Part,
            YoutubeParamKeys.Query: query.replacingOccurrences(of: " ", with: "+")
        ]

        _ = customRequest(.get, [:], CustomURLs.YoutubeSearch, params as [String : AnyObject], completion: { (results, message) in

            if let error = message {
                print(error.localizedDescription)
                completion(nil, false, ResponseMessages.ServerError)
                return
            } else if let results = results {

                guard let response = results as? [String : AnyObject] else {
                    completion(nil, false, ResponseMessages.InvalidParams)
                    return
                }

                if let itemsObject = response[Client.YoutubeResponseKeys.Items] as? [[String : AnyObject]] {
                    if let items = itemsObject[0][Client.YoutubeResponseKeys.ID] as? [String : AnyObject] {
                        let videoID = items[Client.YoutubeResponseKeys.VideoID] as? String
                        completion(videoID, true, nil)
                    }
                }
                return

            }

        })

    }

}
