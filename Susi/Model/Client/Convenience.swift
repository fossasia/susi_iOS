//
//  Convenience.swift
//  Susi
//
//  Created by Chashmeet Singh on 31/01/17.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import Foundation
import RealmSwift

extension Client {

    // MARK: - Auth Methods

    func loginUser(_ params: [String : AnyObject], _ completion: @escaping(_ user: User?, _ success: Bool, _ error: String) -> Void) {

        let url = getApiUrl(UserDefaults.standard.object(forKey: ControllerConstants.UserDefaultsKeys.ipAddress) as! String, Methods.Login)

        _ = makeRequest(url, .post, [:], parameters: params, completion: { (results, message) in

            if let _ = message {
                completion(nil, false, ResponseMessages.InvalidParams)
            } else if let results = results as? [String : AnyObject] {

                let user = User(dictionary: results)

                UserDefaults.standard.set(results, forKey: ControllerConstants.UserDefaultsKeys.user)
                completion(user, true, user.message)
            }
            return
        })

    }

    func registerUser(_ params: [String : AnyObject], _ completion: @escaping(_ success: Bool, _ error: String) -> Void) {

        let url = getApiUrl(UserDefaults.standard.object(forKey: ControllerConstants.UserDefaultsKeys.ipAddress) as! String, Methods.Register)

        _ = makeRequest(url, .post, [:], parameters: params, completion: { (results, message) in

            if let _ = message {
                completion(false, ResponseMessages.ServerError)
            } else if let results = results {

                guard let successMessage = results[UserKeys.Message] as? String else {
                    completion(false, ResponseMessages.InvalidParams)
                    return
                }

                completion(true, successMessage)
            }
            return

        })

    }

    func resetPassword(_ params: [String : AnyObject], _ completion: @escaping(_ success: Bool, _ error: String) -> Void) {

        let url = getApiUrl(UserDefaults.standard.object(forKey: ControllerConstants.UserDefaultsKeys.ipAddress) as! String, Methods.ResetPassword)

        _ = makeRequest(url, .get, [:], parameters: params, completion: { (results, message) in

            if let _ = message {
                completion(false, ResponseMessages.ServerError)
            } else if let results = results {

                guard let successMessage = results[UserKeys.Message] as? String else {
                    completion(false, ResponseMessages.InvalidParams)
                    return
                }

                completion(true, successMessage)
            }
            return
        })

    }

    func logoutUser(_ completion: @escaping(_ success: Bool, _ error: String) -> Void) {

        UserDefaults.standard.removeObject(forKey: ControllerConstants.UserDefaultsKeys.user)
        completion(true, ResponseMessages.SignedOut)

    }

    // MARK: - Chat Methods

    func queryResponse(_ params: [String : AnyObject], _ completion: @escaping(_ messages: List<Message>?, _ success: Bool, _ error: String?) -> Void) {

        let url = getApiUrl(UserDefaults.standard.object(forKey: ControllerConstants.UserDefaultsKeys.ipAddress) as! String, Methods.Chat)

        _ = makeRequest(url, .get, [:], parameters: params, completion: { (results, message) in

            if let _ = message {
                completion(nil, false, ResponseMessages.ServerError)
            } else if let results = results {

                guard let response = results as? [String : AnyObject] else {
                    completion(nil, false, ResponseMessages.InvalidParams)
                    return
                }

                let messages = Message.getAllAction(data: response)
                completion(messages, true, nil)
            }
            return
        })

    }

    // MARK: - Web Search by DuckDuckGo

    func websearch(_ params: [String : AnyObject], _ completion: @escaping(_ response: List<WebsearchAction>?, _ success: Bool, _ error: String?) -> Void) {

        let url = getApiUrl(APIURLs.DuckDuckGo)

        _ = makeRequest(url, .get, [:], parameters: params, completion: { (results, message) in

            if let _ = message {
                completion(nil, false, ResponseMessages.ServerError)
            } else if let results = results {

                guard let response = results as? [String : AnyObject] else {
                    completion(nil, false, ResponseMessages.InvalidParams)
                    return
                }

                if let result = response[Client.WebsearchKeys.RelatedTopics] as? [[String : AnyObject]] {
                    let results = WebsearchAction.getSearchResults(result)
                    completion(results, true, nil)
                } else {
                    completion(nil, false, "Result empty")
                }
            }
            return
        })

    }

    // MARK: - Youtube Video Search by Youtube Data API v3

    func searchYotubeVideos(_ query: String, _ completion: @escaping(_ response: String?, _ success: Bool, _ error: String?) -> Void) {

        let params = [
            YoutubeParamKeys.Key: YoutubeParamValues.Key,
            YoutubeParamKeys.Part: YoutubeParamValues.Part,
            YoutubeParamKeys.Query: query.replacingOccurrences(of: " ", with: "+")
        ]

        let url = getApiUrl(APIURLs.YoutubeSearch)

        _ = makeRequest(url, .get, [:], parameters: params as [String : AnyObject], completion: { (results, message) in

            if let _ = message {
                completion(nil, false, ResponseMessages.ServerError)
            } else if let results = results {

                guard let response = results as? [String : AnyObject] else {
                    completion(nil, false, ResponseMessages.InvalidParams)
                    return
                }

                if let itemsObject = response[Client.YoutubeResponseKeys.Items] as? [[String : AnyObject]] {
                    if itemsObject.count > 0 {
                        if let items = itemsObject[0][Client.YoutubeResponseKeys.ID] as? [String : AnyObject] {
                            let videoID = items[Client.YoutubeResponseKeys.VideoID] as? String
                            completion(videoID, true, nil)
                        }
                    } else {
                        completion(nil, false, ResponseMessages.ServerError)
                    }
                }
            }
            return
        })

    }

}
