//
//  VideoPlayAction.swift
//  Susi
//
//  Created by JOGENDRA on 05/07/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import Foundation
import RealmSwift

class VideoPlayAction: Object {
    @objc dynamic var identifier: String = ""

    convenience init(action: [String: AnyObject]) {
        self.init()
        identifier = action[Client.ChatKeys.Identifier] as? String ?? ""
    }

}
