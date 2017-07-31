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
        initializeRealm()
        resetStateIfUITesting()
        checkAndSetTheme()
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

    func checkAndSetTheme() {
        let key = ControllerConstants.UserDefaultsKeys.theme
        guard let _ = UserDefaults.standard.string(forKey: key) else {
            UserDefaults.standard.set(theme.light.rawValue, forKey: ControllerConstants.UserDefaultsKeys.theme)
            return
        }
    }

}
