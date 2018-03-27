//
//  MapAction.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-10.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import Foundation
import RealmSwift

class MapAction: Object {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var zoom: Int = 12

    convenience init(action: [String: AnyObject]) {
        self.init()
        latitude = Double(action[Client.ChatKeys.Latitude] as? String ?? "0.0")!
        longitude = Double(action[Client.ChatKeys.Longitude] as? String ?? "0.0")!
        zoom = Int(action[Client.ChatKeys.Zoom] as? String ?? "12")!
    }

}
