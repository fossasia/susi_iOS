//
//  AppDelegate.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    var window: UIWindow?

    // user
    var currentUser: User?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initializeRealm()
        resetStateIfUITesting()
        checkAndAssignDefaultIfFirstLaunch()
        listenForReachability()
        return true
    }
    
    func listenForReachability() {
        self.reachabilityManager?.listener = { status in
            print("Network Status Changed: \(status)")
            switch status {
            case .notReachable:
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                break
            case .reachable(_), .unknown:
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                break
            }
        }
        
        self.reachabilityManager?.startListening()
    }
    
    func initializeRealm() {
        var config = Realm.Configuration(schemaVersion: 1, migrationBlock: nil)

        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("susi.realm")
        Realm.Configuration.defaultConfiguration = config
    }

    func resetStateIfUITesting() {
        if ProcessInfo.processInfo.arguments.contains("UI-Testing") {
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.set(Client.APIURLs.SusiAPI, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
        }
    }

    func checkAndAssignDefaultIfFirstLaunch() {
        let lanuchedBefore = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.lanuchedBefore)
        if !lanuchedBefore {
            UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.enterToSend)
            UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.micInput)
            UserDefaults.standard.set(false, forKey: ControllerConstants.UserDefaultsKeys.hotwordEnabled)
            UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.speechOutput)
            UserDefaults.standard.set(false, forKey: ControllerConstants.UserDefaultsKeys.speechOutputAlwaysOn)
            UserDefaults.standard.set(0.5, forKey: ControllerConstants.UserDefaultsKeys.speechRate)
            UserDefaults.standard.set(1.0, forKey: ControllerConstants.UserDefaultsKeys.speechPitch)
            UserDefaults.standard.set("en", forKey: ControllerConstants.UserDefaultsKeys.prefLanguage)
            UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.lanuchedBefore)
        }
    }

}
