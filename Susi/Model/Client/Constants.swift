//
//  Constants.swift
//  Susi
//
//  Created by Chashmeet Singh on 31/01/17.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

extension Client {

    struct APIURLs {
        static let SusiAPI = "http://api.susi.ai"
        static let DuckDuckGo = "http://api.duckduckgo.com"
        static let YoutubeSearch = "https://www.googleapis.com/youtube/v3/search"
        static let SnowboyTrain = "https://snowboy.kitt.ai/api/v1/train/"
    }

    struct Methods {
        static let Login = "/aaa/login.json"
        static let Register = "/aaa/signup.json"
        static let Chat = "/susi/chat.json"
        static let ResetPassword = "/aaa/recoverpassword.json"
        static let Memory = "/susi/memory.json"
        static let UserSettings = "/aaa/changeUserSettings.json"
        static let ListUserSettings = "/aaa/listUserSettings.json"
        static let SendFeedback = "/cms/rateSkill.json"
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
        static let ForgotEmail = "forgotemail"
        static let ValidSeconds = "valid_seconds"
    }

    struct ChatKeys {
        static let Answers = "answers"
        static let Query = "query"
        static let TimeZoneOffset = "timezoneOffset"
        static let AnswerDate = "answer_date"
        static let ResponseType = "type"
        static let Expression = "expression"
        static let Actions = "actions"
        static let Skills = "skills"
        static let AccessToken = "access-token"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let Zoom = "zoom"
        static let Language = "language"
        static let Data = "data"
        static let Count = "count"
        static let Title = "title"
        static let Link = "link"
        static let Description = "description"
        static let Text = "text"
        static let Columns = "columns"
        static let QueryDate = "query_date"
        static let ShortenedUrl = "finalUrl"
        static let Image = "image"
        static let Cognitions = "cognitions"
    }

    struct WebsearchKeys {
        static let RelatedTopics = "RelatedTopics"
        static let Icon = "Icon"
        static let Url = "URL"
        static let FirstURL = "FirstURL"
        static let Text = "Text"
        static let Heading = "Heading"
        static let Format = "format"
        static let Query = "q"
        static let Result = "Result"
    }

    struct YoutubeParamKeys {
        static let Part = "part"
        static let Query = "q"
        static let Key = "key"
    }

    struct YoutubeParamValues {
        static let Part = "snippet"
        static let Key = "AIzaSyAx6TqPYDDL2VekgdEU-8kHHfplJSmqoTw"
    }

    struct YoutubeResponseKeys {
        static let Items = "items"
        static let ID = "id"
        static let VideoID = "videoId"
    }

    struct WebSearch {
        static let image = "no-image"
        static let noData = "No data found"
        static let duckDuckGo = "https://duckduckgo.com/"
        static let noDescription = "No Description"
    }

    struct FeedbackKeys {
        static let model = "model"
        static let group = "group"
        static let skill = "skill"
        static let language = "language"
        static let rating = "rating"
    }

}
