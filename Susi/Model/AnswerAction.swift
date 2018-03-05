//
//  AnswerAction.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-10.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import Foundation
import RealmSwift

class AnswerAction: Object {
    @objc dynamic var expression: String = ""
    @objc dynamic var language: String?

    convenience init(action: [String: AnyObject]) {
        self.init()
        expression = action[Client.ChatKeys.Expression] as? String ?? ""
        language = action[Client.ChatKeys.Language] as? String
    }
}
