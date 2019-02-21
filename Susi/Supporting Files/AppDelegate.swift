//
//  AppDelegate.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import RealmSwift
import BouncyLayout

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var shortcutHandled: Bool!
    var shortcutIdentifier: String?

    // user
    var currentUser: User?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.isStatusBarHidden = false
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
            UserDefaults.standard.set(false, forKey: ControllerConstants.UserDefaultsKeys.lanuchedBefore)
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
            UserDefaults.standard.set(true, forKey: ControllerConstants.UserDefaultsKeys.speechToTextAvailable)

            self.presentOnboardingScreens()
        }

        self.checkSession()
    }

    func presentOnboardingScreens() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let onboardingViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingVC")
        self.window?.rootViewController = onboardingViewController
        self.window?.makeKeyAndVisible()
    }

    func presentLoginScreens() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginController")
        self.window?.rootViewController = loginViewController
        self.window?.makeKeyAndVisible()
    }

    func presetChatScreen() {
        let layout = BouncyLayout()
        let vc = ChatViewController(collectionViewLayout: layout)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }

    // Check existing session
    func checkSession() {
        if let userDefaultValue = UserDefaults.standard.value(forKey: ControllerConstants.UserDefaultsKeys.user) {
            if let userData = userDefaultValue as? [String: AnyObject] {
                let user = User(dictionary: userData)
                currentUser = user

                if user.expiryTime > Date() {
                    self.presetChatScreen()
                } else {
                    self.resetDB()
                    self.presentLoginScreens()
                }
            }
        }
    }

    func resetDB() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        shortcutIdentifier = shortcutItem.type
        shortcutHandled = true
        completionHandler(shortcutHandled)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if shortcutHandled == true {
            shortcutHandled = false
            if shortcutIdentifier == "OpenSkillAction" {
                self.window?.rootViewController = ChatViewController( shouldOpenSkillListing: true)
                self.window?.makeKeyAndVisible()
            }
        }
    }
}
