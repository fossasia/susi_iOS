//
//  CustomBannerColors.swift
//  Susi
//
//  Created by Syed on 17/12/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import Foundation
import NotificationBannerSwift


class CustomBannerColors: BannerColorsProtocol {
    
    internal func color(for style: BannerStyle) -> UIColor {
        switch style {
        case .danger:   return UIColor(red:0.90, green:0.31, blue:0.26, alpha:1.00)
        case .info:     return UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.00)
        case .none:     return UIColor.clear
        case .success:  return UIColor(red:0.22, green:0.80, blue:0.46, alpha:1.00)
        case .warning:  return UIColor(red:1.00, green:0.66, blue:0.16, alpha:1.00)
           }
    }
    
}
