//
//  AppDelegate.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = .lightContent
        initializeUserSettings()
                        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = LoginViewController()
        
        return true
    }
    
    func initializeUserSettings() {
        
        let firstLaunch = UserDefaults.standard.bool(forKey: "firstLaunch")
        
        if !firstLaunch {
            UserDefaults.standard.set(true, forKey: "firstLaunch")
            UserDefaults.standard.set(false, forKey: "enterToSend")
            UserDefaults.standard.set(false, forKey: "micInput")
            UserDefaults.standard.set(false, forKey: "speechOutput")
            UserDefaults.standard.set(false, forKey: "speechOutputAlwaysOn")
        }
        
    }

}

