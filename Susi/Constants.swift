//
//  Constants.swift
//  MeetingApp
//
//  Created by Chashmeet Singh on 31/01/17.
//  Copyright © 2017 Chashmeet Singh. All rights reserved.
//

extension Client {

    struct API {
        static let APIScheme = "http"
        static let BaseUrl = "api.asksusi.com"
    }

    struct Methods {
        static let Login = "/aaa/login.json"
        static let Register = "/aaa/signup.json"
        static let Chat = "/susi/chat.json"
    }

    struct ResponseMessages {
        static let InvalidParams = "Email ID / Password incorrect"
        static let ServerError = "Problem connecting to server!"
        static let SignedOut = "Successfully logged out"
    }

    struct UserKeys {
        static let AccessToken = "access_token"
        static let Message = "message"
        static let Login = "login"
        static let SignUp = "signup"
        static let Password = "password"
    }
    
    struct ChatKeys {
        static let Answers = "answers"
        static let Query = "q"
        static let TimeZoneOffset = "timezoneOffset"
        static let AnswerDate = "answer_date"
        static let ResponseType = "type"
        static let Expression = "expression"
        static let Actions = "actions"
        static let AccessToken = "access-token"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let Zoom = "zoom"
    }

}
