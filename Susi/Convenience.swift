//
//  Convenience.swift
//  MeetingApp
//
//  Created by Chashmeet Singh on 31/01/17.
//  Copyright © 2017 Chashmeet Singh. All rights reserved.
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
    
    func queryResponse(_ params: [String : AnyObject], _ completion: @escaping(_ response: Message?, _ success: Bool, _ error: String) -> Void) {
        
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
                
                completion(message, true, "cool")
                return
                
            }
            
        })
        
    }
    
    func websearch(_ params: [String : AnyObject], _ completion: @escaping(_ response: WebsearchResult?, _ success: Bool, _ error: String) -> Void) {
        
//        _ = makeRequest(.get, [:], Methods.Chat, parameters: params, completion: { (results, message) in
//            
//            if let error = message {
//                print(error.localizedDescription)
//                completion(nil, false, ResponseMessages.ServerError)
//                return
//            } else if let results = results {
//                
//                guard let response = results as? [String : AnyObject] else {
//                    completion(nil, false, ResponseMessages.InvalidParams)
//                    return
//                }
//                
//                let searchResult = WebsearchResult(dictionary: response)
//                
//                completion(searchResult, true, ResponseMessages.ServerError)
//                return
//                
//            }
//            
//        })
        
    }

}
