//
//  Client.swift
//  Susi
//
//  Created by Chashmeet Singh on 31/01/17.
//  Copyright © 2017 FOSSAsia. All rights reserved.
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
            let userInfo = [NSLocalizedDescriptionKey: error]
            completion(nil, NSError(domain: "makeRequestMethod", code: 1, userInfo: userInfo))
        }

        let url = getApiUrl(method)

        Alamofire.request(url, method: httpMethod, parameters: parameters, encoding: URLEncoding(destination: .methodDependent), headers: headers).validate().responseJSON { (response: DataResponse<Any>) in

            switch(response.result) {

            case .success(_):
                if let data = response.result.value as? Dictionary<String, Any> {
                    completion(data as AnyObject?, nil)
                } else {
                    completion(nil, NSError(domain: ResponseMessages.ServerError, code: 1))
                }
                break

            case .failure(let error):
                debugPrint(error.localizedDescription)
                sendError(ResponseMessages.ServerError)
                break
            }

        }
    }

    func customRequest(_ httpMethod: HTTPMethod, _ headers: HTTPHeaders, _ url: String, _ parameters: [String : AnyObject], completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {

        func sendError(_ error: String) {
            let userInfo = [NSLocalizedDescriptionKey: error]
            completion(nil, NSError(domain: "customRequest", code: 1, userInfo: userInfo))
        }

        Alamofire.request(url, method: httpMethod, parameters: parameters, encoding: URLEncoding(destination: .methodDependent), headers: headers).validate().responseJSON { (response: DataResponse<Any>) in

            switch(response.result) {

            case .success(_):
                if let data = response.result.value as? Dictionary<String, Any> {
                    completion(data as AnyObject?, nil)
                } else {
                    completion(nil, NSError(domain: ResponseMessages.ServerError, code: 1))
                }
                break

            case .failure(let error):
                debugPrint(error.localizedDescription)
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
