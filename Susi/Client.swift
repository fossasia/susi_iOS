//
//  Client.swift
//  MeetingApp
//
//  Created by Chashmeet Singh on 31/01/17.
//  Copyright © 2017 Chashmeet Singh. All rights reserved.
//

import Foundation
import UIKit

class Client: NSObject {

    static let sharedInstance = Client()
    var session: URLSession

    private override init() {
        session = URLSession.shared
    }
    
    // MARK: POST Methods
    func taskForGETMethod(_ method: String, parameters: [String:String], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parameters = parameters
        
        /* 2/3. Build the URL, Configure the request */
        let urlString = "\(getApiUrl(forMethod: method))" + escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(url: url as URL)
        
        print(request)
        print(parameters)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode < 500 else {
                sendError("Error establishing connection to the server!")
                return
            }
            print(statusCode)
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.parseJSONWithCompletionHandler(data, completionHandler: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }

    // MARK: POST Methods
    func taskForPOSTMethod(_ parseToJSON: Bool, _ method: String, parameters: [String:AnyObject], completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {

        /* 1. Set the parameters */
        var parameters = parameters

        /* 2/3. Build the URL, Configure the request */
        var request = URLRequest(url: getApiUrl(forMethod: method))
        request.httpMethod = "POST"

        print(request)
        print(parameters)

        if parseToJSON {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
            } catch {
                let userInfo = [NSLocalizedDescriptionKey: "Error parsing create object"]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
        } else {
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = httpBody(forParams: parameters as! [String : String])
        }

        /* 4. Make the request */
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in

            func sendError(_ error: String) {

                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
            }

            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }

            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }

            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode < 500 else {
                sendError("Error establishing connection to the server!")
                return
            }
            print(statusCode)

            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.parseJSONWithCompletionHandler(data, completionHandler: completionHandlerForPOST)
        })

        /* 7. Start the request */
        task.resume()

        return task
    }

    // MARK: Helper Methods
    private func escapedParameters(_ parameters: [String : String]) -> String {

        var urlVars = [String]()

        for (key, value) in parameters {

            /* Make sure that it is a string value */
            let stringValue = "\(value)"

            /* Escape it */
            let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]

        }

        return (!urlVars.isEmpty ? "?" : "") + urlVars.joined(separator: "&")
    }

    /* Parsing JSON */
    private func parseJSONWithCompletionHandler(_ data: Data, completionHandler: (_ result: AnyObject?, _ error: NSError?) -> Void) {

        var parsedResult: Any!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandler(nil, NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandler(parsedResult as AnyObject?, nil)
    }

    func httpBody(forParams params: [String: String]) -> Data? {
        var bodyString: String = ""
        for (key, value) in params {
            bodyString += bodyString == "" ? "" : "&"
            bodyString += "\(key)=\(value)"
        }
        return bodyString.data(using: .utf8)
    }

    // create a URL
    func getApiUrl(forMethod method: String) -> URL {

        var components = URLComponents()
        components.scheme = Client.API.APIScheme
        components.host = Client.API.BaseUrl
        components.path = method
        return components.url!
    }

}
