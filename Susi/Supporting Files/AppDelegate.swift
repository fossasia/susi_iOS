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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        resetStateIfUITesting()

        initializeRealm()
        initializeUserSettings()

//        UIApplication.shared.statusBarStyle = .lightContent
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
//        window?.rootViewController = LoginViewController()

        return true
    }

    func initializeRealm() {
        var config = Realm.Configuration(schemaVersion: 1,
            migrationBlock: { _, oldSchemaVersion in
                if oldSchemaVersion < 0 {
                    // Nothing to do!
                }
        })

        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("susi.realm")
        Realm.Configuration.defaultConfiguration = config
    }

    func initializeUserSettings() {
        let firstLaunch = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.firstLaunch)

        if !firstLaunch {
            UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.firstLaunch)
            UserDefaults.standard.set(false, forKey: ControllerConstants.UserDefaultsKeys.enterToSend)
            UserDefaults.standard.set(false, forKey: ControllerConstants.UserDefaultsKeys.micInput)
            UserDefaults.standard.set(false, forKey: ControllerConstants.UserDefaultsKeys.speechOutput)
            UserDefaults.standard.set(false, forKey: ControllerConstants.UserDefaultsKeys.speechOutputAlwaysOn)
            UserDefaults.standard.set(false, forKey: ControllerConstants.UserDefaultsKeys.hotwordEnabled)
        }

    }

    func resetStateIfUITesting() {
        if ProcessInfo.processInfo.arguments.contains("UI-Testing") {
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            initializeUserSettings()
            UserDefaults.standard.set(Client.APIURLs.SusiAPI, forKey: ControllerConstants.UserDefaultsKeys.ipAddress)
        }
    }

}
