//
//  Client.swift
//  MeetingApp
//
//  Created by Chashmeet Singh on 31/01/17.
//  Copyright © 2017 Chashmeet Singh. All rights reserved.
//

import UIKit
import Alamofire

class Client: NSObject {

    static let sharedInstance = Client()
    var session: URLSession

    private override init() {
        session = URLSession.shared
    }
    
    func makeRequest(_ httpMethod: HTTPMethod, _ headers: HTTPHeaders, _ method: String, parameters: [String:AnyObject], completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        func sendError(_ error: String) {
            let userInfo = [NSLocalizedDescriptionKey : error]
            completion(nil, NSError(domain: "makeRequestMethod", code: 1, userInfo: userInfo))
        }
        
        let parameters = parameters
        print(parameters)
        
        let url = getApiUrl(method)
        
        Alamofire.request(url, method: httpMethod, parameters: parameters, encoding: URLEncoding(destination: .methodDependent), headers: headers).validate().responseJSON { (response:DataResponse<Any>) in
            
            print(response.result, response.error?.localizedDescription, response.request?.urlRequest)
            
            switch(response.result) {
                
            case .success(_):
                
                if let data = response.result.value as? Dictionary<String, Any> {
                    
                    completion(data as AnyObject?, nil)
                    
                } else {
                    completion(nil, NSError(domain: ResponseMessages.ServerError, code: 1))
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                sendError(ResponseMessages.ServerError)
                break
            }
            
        }
    }

    // create a URL
    func getApiUrl(_ method: String) -> URL {
        var components = URLComponents()
        components.scheme = Client.API.APIScheme
        components.host = Client.API.BaseUrl
        components.path = method
        return components.url!
    }

}
