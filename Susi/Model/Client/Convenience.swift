//
//  Convenience.swift
//  Susi
//
//  Created by Chashmeet Singh on 31/01/17.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

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

    func recoverPassword(_ params: [String : AnyObject], _ completion: @escaping(_ success: Bool, _ error: String) -> Void) {

        let url = getApiUrl(UserDefaults.standard.object(forKey: ControllerConstants.UserDefaultsKeys.ipAddress) as! String, Methods.RecoverPassword)

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

    func getMessagesFromMemory(_ params: [String : AnyObject], _ completion: @escaping(_ messages: List<Message>?, _ success: Bool, _ error: String?) -> Void) {

        let url = getApiUrl(UserDefaults.standard.object(forKey: ControllerConstants.UserDefaultsKeys.ipAddress) as! String, Methods.Memory)

        _ = makeRequest(url, .get, [:], parameters: params, completion: { (results, error) in

            if let _ = error {
                completion(nil, false, error!.localizedDescription)
            } else if let results = results {

                guard let cognitions = results[Client.ChatKeys.Cognitions] as? [[String : AnyObject]] else {
                    completion(nil, false, ResponseMessages.ServerError)
                    return
                }

                let messages = Message.getMessagesFromMemory(cognitions)
                completion(messages, true, nil)

            }
            return

        })

    }

    func logoutUser(_ completion: @escaping(_ success: Bool, _ error: String) -> Void) {

        UserDefaults.standard.removeObject(forKey: ControllerConstants.UserDefaultsKeys.user)
        completion(true, ResponseMessages.SignedOut)

    }

    func changeUserSettings(_ params: [String : AnyObject], _ completion: @escaping(_ success: Bool, _ error: String) -> Void) {

        let url = getApiUrl(UserDefaults.standard.object(forKey: ControllerConstants.UserDefaultsKeys.ipAddress) as! String, Methods.UserSettings)

        _ = makeRequest(url, .get, [:], parameters: params, completion: { (results, message) in

            if let _ = message {
                completion(false, ResponseMessages.ServerError)
            } else if let results = results {

                guard let response = results as? [String : AnyObject] else {
                    completion(false, ResponseMessages.ServerError)
                    return
                }

                if let accepted = response[ControllerConstants.accepted] as? Bool, let message = response[Client.UserKeys.Message] as? String {
                    if accepted {
                        completion(true, message)
                        return
                    }
                    completion(false, message)
                    return
                }

            }
            return
        })

    }

    func fetchUserSettings(_ params: [String : AnyObject], _ completion: @escaping(_ success: Bool, _ error: String) -> Void) {

        let url = getApiUrl(UserDefaults.standard.object(forKey: ControllerConstants.UserDefaultsKeys.ipAddress) as! String, Methods.ListUserSettings)

        _ = makeRequest(url, .get, [:], parameters: params, completion: { (results, message) in

            if let _ = message {
                completion(false, ResponseMessages.ServerError)
            } else if let results = results {

                guard let response = results as? [String : AnyObject] else {
                    completion(false, ResponseMessages.ServerError)
                    return
                }

                guard let settings = response[ControllerConstants.settings.lowercased()] as? [String:String] else {
                    completion(false, ResponseMessages.ServerError)
                    return
                }

                for (key, value) in settings {
                    if value.toBool() != nil {
                        UserDefaults.standard.set(value.toBool()!, forKey: key)
                    } else {
                        UserDefaults.standard.set(value, forKey: key)
                    }
                }
                completion(true, response[Client.UserKeys.Message] as? String ?? "error")

            }
            return
        })

    }

    func resetPassword(_ params: [String : AnyObject], _ completion: @escaping(_ success: Bool, _ error: String) -> Void) {

        let url = getApiUrl(UserDefaults.standard.object(forKey: ControllerConstants.UserDefaultsKeys.ipAddress) as! String, Methods.ChangePassword)

        _ = makeRequest(url, .get, [:], parameters: params, completion: { (results, message) in

            if let _ = message {
                completion(false, ResponseMessages.ServerError)
            } else if let results = results {

                guard let response = results as? [String : AnyObject] else {
                    completion(false, ResponseMessages.PasswordInvalid)
                    return
                }

                if let accepted = response[ControllerConstants.accepted] as? Bool,
                    let message = response[Client.UserKeys.Message] as? String {
                    if accepted {
                            completion(true, message)
                    } else {
                        completion(false, message)
                    }
                } else {
                    completion(false, ResponseMessages.PasswordInvalid)
                }
                return
            }
            return
        })

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

    func sendFeedback(_ params: [String : AnyObject], _ completion: @escaping(_ success: Bool, _ error: String?) -> Void) {

        let url = getApiUrl(UserDefaults.standard.object(forKey: ControllerConstants.UserDefaultsKeys.ipAddress) as! String, Methods.SendFeedback)

        _ = makeRequest(url, .get, [:], parameters: params, completion: { (results, message) in

            if let _ = message {
                completion(false, ResponseMessages.ServerError)
            } else if let results = results {

                guard let response = results as? [String : AnyObject] else {
                    completion(false, ResponseMessages.InvalidParams)
                    return
                }

                if let accepted = response[ControllerConstants.accepted] as? Bool {
                    if accepted {
                        completion(true, nil)
                        return
                    }
                    completion(false, ResponseMessages.ServerError)
                    return
                }
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

    // MARK: - Train hotword using Snowboy API

    func trainHotwordUsingSnowboy(_ params: [String : AnyObject], _ completion: @escaping(_ success: Bool, _ error: String?) -> Void) {

        let urlString = getApiUrl(APIURLs.SnowboyTrain)

        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try! JSONSerialization.data(withJSONObject: params)

        Alamofire.request(request).responseData { (results) in
            if results.response?.statusCode == 201 {
                if let data = results.data {
                    //this is the file. we will write to and read from it
                    let file = ControllerConstants.hotwordFileName

                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

                        let path = dir.appendingPathComponent(file)

                        //writing
                        do {
                            try data.write(to: path)
                            completion(true, nil)
                            return
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            print(results.error?.localizedDescription ?? "Error")
            completion(false, ResponseMessages.ServerError)
            return
        }

    }

}
