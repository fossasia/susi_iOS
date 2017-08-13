//
//  AppDelegate.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // user
    var currentUser: User?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initializeRealm()
        resetStateIfUITesting()
        checkAndAssignDefaultIfFirstLaunch()
        return true
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
            UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.hotwordEnabled)
            UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.speechOutput)
            UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.speechOutputAlwaysOn)
            UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.lanuchedBefore)
            UserDefaults.standard.set(0.5, forKey: ControllerConstants.UserDefaultsKeys.speechRate)
            UserDefaults.standard.set(0.5, forKey: ControllerConstants.UserDefaultsKeys.speechRate)
            UserDefaults.standard.set("en", forKey: ControllerConstants.UserDefaultsKeys.prefLanguage)
        }
    }

}
