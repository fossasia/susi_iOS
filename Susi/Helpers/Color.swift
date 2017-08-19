//
//  File.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

extension UIColor {

    class func defaultColor() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#4184F3")
    }

    class func chatBackgroundColor() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#EEEEEE")
    }

    class func activityIndicatorCellColor() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#757575")
    }

    class func thumbsSelectedColor() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#2196F3")
    }

    class func outgoingCellBackgroundColor() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#E0E0E0")
    }

}
