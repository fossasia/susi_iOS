//
//  AppNavigationController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-15.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class AppNavigationController: NavigationController {
    
    // Configures Navigation Controller
    open override func prepare() {
        super.prepare()
        guard let v = navigationBar as? NavigationBar else {
            return
        }
        
        v.depthPreset = .none
        v.dividerColor = UIColor.defaultColor()
        v.backgroundColor = UIColor.defaultColor()
    }
}
