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
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var zoom: Int = 13

    convenience init(action: [String : AnyObject]) {
        self.init()

        if let latitude = action[Client.ChatKeys.Latitude] as? String,
            let longitude = action[Client.ChatKeys.Longitude] as? String,
            let zoom = action[Client.ChatKeys.Zoom] as? String {
            self.longitude = Double(longitude)!
            self.latitude = Double(latitude)!
            self.zoom = Int(zoom)!
        }

    }

}
