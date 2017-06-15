//
//  AnchorAction.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-10.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import Foundation
import RealmSwift

class AnchorAction: Object {
    dynamic var link: String = ""
    dynamic var text: String = ""

    convenience init(action: [String : AnyObject]) {
        self.init()

        if let link = action[Client.ChatKeys.Link] as? String,
            let text = action[Client.ChatKeys.Text] as? String {
            self.link = link
            self.text = text
        }
    }
}
