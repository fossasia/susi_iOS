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
    @objc dynamic var link: String = ""
    @objc dynamic var text: String = ""

    convenience init(action: [String: AnyObject]) {
        self.init()
        link = action[Client.ChatKeys.Link] as? String ?? ""
        text = action[Client.ChatKeys.Text] as? String ?? ""
    }
}
